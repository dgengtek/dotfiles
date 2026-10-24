{ config, options, lib, pkgs, ... }:
let
  accountFilename = account: config.xdg.configHome + "/neomutt/" + account.name;
  cfg = config.dotfiles.email;
  addAttachments = pkgs.writeShellApplication {
    name = "addAttachments";
    runtimeInputs = [ pkgs.fzf pkgs.fd ];
    text = ''
      cd "$HOME"

      export FZF_DEFAULT_COMMAND='fd -t f -e pdf -e png -e jpg -e zip -e tar -e gz -e rar -e html -e md --absolute-path'

      while read -d $'\0' -r attachment; do
        echo "push 'a$attachment<enter>'"
      done < <(fzf --print0 -m --prompt='Choose attachments >')
    '';
  };
in
{
  options.dotfiles.email = with lib; {
    enable = mkEnableOption "email";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.lynx
      pkgs.poppler-utils
      pkgs.pandoc
    ];

    xdg.configFile."mailcap".text = ''
      text/html; lynx -dump %s; needsterminal; copiousoutput
      text/*; nvim -R %s; needsterminal

      application/msword; pandoc --from docx --to plain %s; copiousoutput
      application/rtf; pandoc --from rtf --to plain %s; copiousoutput
      image/*; swayimg %s
      # application/postscript ; xdg-open %s ; copiousoutput
      # application/pdf; pdftotext -layout %s -; copiousoutput;
      # application/pdf; xdg-open %s ; copiousoutput
    '';
    programs.neomutt = {
      # https://docs.neomutt.org/reference/config
      enable = true;
      unmailboxes = true;
      binds = [
        {
          key = "c";
          map = [ "index" ];
          action = "noop";
        }
        {
          key = "cd";
          map = [ "index" ];
          action = "noop";
        }
      ];
      extraConfig = ''
        set pgp_default_key = E8A7BB8D37C341113C3DCAD8853206476F1DF5A1
        set pgp_sign_as = 0x7239FA16084C3CAD
        set hidden_host
        set abort_nosubject
        set status_on_top
        set menu_move_off = no
        set menu_scroll = no
        unset message_id_format

        set sort_alias = alias
        set reverse_alias = yes

        set quit=ask-yes
        #set ssl_verify_host=no

        set connect_timeout = 10
        set imap_keepalive = 30
        set imap_passive = yes
        set imap_poll_timeout = 0
        set mail_check = 60
        set imap_check_subscribed = yes

        set sort = threads
        set sort_aux = reverse-last-date-received

        set charset = utf-8
        set send_charset = utf-8

        # edit headers when composing
        set edit_headers = yes
        # no attachments forwarding as part of body
        set mime_forward = ask-no
        set mark_old = yes
        set shell = /bin/bash
        set forward_format = 'Forward: [%a: %s]'

        # stop pager when message end
        set pager_stop = yes
        set pager_index_lines = 11
        set pager_context = 6
        set tilde
        unset markers

        # view html
        alternative_order text/plain text/enriched text/html

        bind attach <return> view-mailcap
        set mailcap_path = "${config.xdg.configHome}/mailcap"
        set preferred_languages = "de,en"

        unbind index y
        unbind editor <space>
        macro compose \Ca ":source ${addAttachments}|<enter>"
        macro index cc "<change-folder>?"

        bind index <f8> imap-fetch-mail

        bind index j next-entry
        bind index k previous-entry
        unbind index J
        bind index Jt next-thread
        unbind index K
        bind index Kt previous-thread
        bind index Jj root-message

        bind index Jn next-new
        bind index Kn previous-new

        bind index Jr next-unread
        bind index Kr previous-unread

        bind index / search
        bind index ? search-reverse
        bind index n search-next
        bind index N search-opposite

        unbind index g
        bind index gg first-entry
        bind index G last-entry

        bind index \Cd half-down
        bind index \Cu half-up

        bind index l collapse-thread
        bind index z collapse-all
        unbind index d
        bind index dt delete-thread
        bind index dm delete-message

        bind index r reply
        bind index a group-reply
        bind index L list-reply

        bind index h limit

        bind index N toggle-new

        # '?' is used for search-opposite
        bind index <F12> help

        # Always start with threads collapsed and with the most recent thread selected
        push <collapse-all><last-entry>

        # Pager

        bind pager j next-line
        bind pager k previous-line

        bind pager <down> next-line
        bind pager <up>   previous-line

        bind pager / search
        bind pager ? search-reverse
        bind pager n search-next
        bind pager N search-opposite

        unbind pager g
        bind pager gg top
        bind pager G bottom

        bind pager \Cd half-down
        bind pager \Cu half-up

        bind pager r reply
        bind pager a group-reply
        bind pager l list-reply
        bind pager L list-reply

        # '?' is used for search-opposite
        bind pager <f12> help

        # ---------- Kanagawa Wave – 256 colour version ----------
        # Works with TERM=alacritty / tmux-256color (no truecolor required)

        # Palette mapping (approximate)
        #  0  #1f1f28 → color236   (main bg)
        #  1  #c34043 → color167   (red)
        #  2  #76946a → color108   (green)
        #  3  #c0a36e → color179   (yellow)
        #  4  #7e9cd8 → color110   (blue)
        #  5  #957fb8 → color139   (magenta)
        #  6  #6a9589 → color109   (cyan)
        #  7  #dcd7ba → color223   (fg / white)
        #  8  #727169 → color243   (bright black)
        #  9  #e82424 → color203   (bright red)
        # 10  #98bb6c → color114   (bright green)
        # 11  #e6c384 → color179   (bright yellow)
        # 12  #7fb4ca → color117   (bright blue)
        # 13  #938aa9 → color146   (bright magenta)
        # 14  #7aa89f → color116   (bright cyan)
        # 15  #dcd7ba → color223   (bright white)
        #     #2a2a37 → color236   (NeoMutt bg)
        #     #363646 → color238   (status bg)

        # Index
        color index          color116 color236 ~N          # new
        color index          color179 color236 ~F          # flagged
        color index          color236 color108 ~T          # tagged
        color index          color203 color236 ~D          # deleted
        color index          color223 color236 ~A          # normal
        mono  index bold ~N
        mono  index bold ~F
        mono  index bold ~T
        mono  index bold ~D

        # Body highlights
        color body color114 color236 "(http|https|ftp|news|telnet|finger)://[^ \"\t\r\n]*"
        color body color114 color236 "mailto:[-a-zA-Z0-9._%+-]+@[-a-zA-Z0-9.]+"
        color body color114 color236 "[-a-zA-Z0-9._%+-]+@[-a-zA-Z0-9.]+\\.[a-zA-Z]{2,}"
        mono  body bold "(http|https|ftp|news|telnet|finger)://[^ \"\t\r\n]*"
        mono  body bold "mailto:[-a-zA-Z0-9._%+-]+@[-a-zA-Z0-9.]+"

        # Headers
        # Core addressing
        color header color108 color236 "^(From|from):"
        color header color108 color236 "^(To|to):"
        color header color108 color236 "^(Cc|cc):"
        color header color108 color236 "^(Bcc|bcc):"
        color header color108 color236 "^(Date|date):"

        # Subject
        color header color116 color236 "^(Subject|subject):"

        # Reply / threading
        color header color179 color236 "^(Reply-To|reply-to):"
        color header color179 color236 "^(In-Reply-To|in-reply-to):"
        color header color179 color236 "^(References|references):"
        color header color179 color236 "^(Message-ID|message-id):"

        # Lists
        color header color110 color236 "^(List-Id|list-id):"
        color header color110 color236 "^(List-Post|list-post):"
        color header color110 color236 "^(List-Unsubscribe|list-unsubscribe):"

        # Meta / technical
        color header color179 color236 "^(User-Agent|user-agent|X-Mailer|x-mailer):"
        color header color179 color236 "^(Organization|organisation|Organisation):"
        color header color179 color236 "^(Content-Type|content-type):"
        color header color179 color236 "^(Content-Transfer-Encoding|content-transfer-encoding):"
        color header color179 color236 "^(MIME-Version|mime-version):"

        # Spam / danger
        color header color203 color236 "^(X-Spam-Status|x-spam-status|X-SpamProbe|x-spamprobe):"
        color header color203 color236 "^(X-Spam-Flag|x-spam-flag):.*YES"
        color header color203 color236 "^(X-SpamProbe|x-spamprobe): SPAM"

        # Quoted text (7 levels)
        color quoted  color109 color236
        color quoted1 color179 color236
        color quoted2 color167 color236
        color quoted3 color108 color236
        color quoted4 color109 color236
        color quoted5 color179 color236
        color quoted6 color167 color236
        color quoted7 color108 color236

        # General UI – NeoMutt has its own background
        color normal     color223 color236
        color indicator  color236 color109          # selected line
        color status     color179 color238          # status bar
        color tree       color110 color236
        color attachment color236 color108
        color signature  color139 color236
        color search     color236 color179
        color error      color203 color236
        color message    color223 color236
        color tilde      color108 color236
        color markers    color116 color236
        color bold       color179 color236
        color progress   color236 color110
        color hdrdefault color223 color236

        # Mono fallbacks
        mono bold bold
        mono underline underline
        mono indicator reverse
      '';
    };
  };
}
