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

        # Colors – Kanagawa Wave
        #--------------------------------------------------------------------------
        set color_directcolor = yes

        # Palette (your definition)
        #  0  #1f1f28   black / bg
        #  1  #c34043   red
        #  2  #76946a   green
        #  3  #c0a36e   yellow
        #  4  #7e9cd8   blue
        #  5  #957fb8   magenta
        #  6  #6a9589   cyan
        #  7  #dcd7ba   white / fg
        #  8  #727169   brightblack
        #  9  #e82424   brightred
        # 10  #98bb6c   brightgreen
        # 11  #e6c384   brightyellow
        # 12  #7fb4ca   brightblue
        # 13  #938aa9   brightmagenta
        # 14  #7aa89f   brightcyan
        # 15  #dcd7ba   brightwhite

        # Index
        color index          #7aa89f #1f1f28 ~N          # new
        color index          #e6c384 #1f1f28 ~F          # flagged
        color index          #1f1f28 #76946a ~T          # tagged
        color index          #e82424 #1f1f28 ~D          # deleted
        color index          #dcd7ba #1f1f28 ~A          # all (normal)
        mono  index bold ~N
        mono  index bold ~F
        mono  index bold ~T
        mono  index bold ~D

        # Body highlights
        color body #98bb6c #1f1f28 "(http|https|ftp|news|telnet|finger)://[^ \"\t\r\n]*"
        color body #98bb6c #1f1f28 "mailto:[-a-zA-Z0-9._%+-]+@[-a-zA-Z0-9.]+"
        color body #98bb6c #1f1f28 "[-a-zA-Z0-9._%+-]+@[-a-zA-Z0-9.]+\\.[a-zA-Z]{2,}"
        mono  body bold "(http|https|ftp|news|telnet|finger)://[^ \"\t\r\n]*"
        mono  body bold "mailto:[-a-zA-Z0-9._%+-]+@[-a-zA-Z0-9.]+"

        # Headers
        # Core addressing
        color header #76946a #1f1f28 "^(From|from):"
        color header #76946a #1f1f28 "^(To|to):"
        color header #76946a #1f1f28 "^(Cc|cc):"
        color header #76946a #1f1f28 "^(Bcc|bcc):"
        color header #76946a #1f1f28 "^(Date|date):"

        # Subject (most important)
        color header #7aa89f #1f1f28 "^(Subject|subject):"

        # Reply / threading
        color header #c0a36e #1f1f28 "^(Reply-To|reply-to):"
        color header #c0a36e #1f1f28 "^(In-Reply-To|in-reply-to):"
        color header #c0a36e #1f1f28 "^(References|references):"
        color header #c0a36e #1f1f28 "^(Message-ID|message-id):"

        # Lists
        color header #7e9cd8 #1f1f28 "^(List-Id|list-id):"
        color header #7e9cd8 #1f1f28 "^(List-Post|list-post):"
        color header #7e9cd8 #1f1f28 "^(List-Unsubscribe|list-unsubscribe):"

        # Meta / technical
        color header #c0a36e #1f1f28 "^(User-Agent|user-agent|X-Mailer|x-mailer):"
        color header #c0a36e #1f1f28 "^(Organization|organisation|Organisation):"
        color header #c0a36e #1f1f28 "^(Content-Type|content-type):"
        color header #c0a36e #1f1f28 "^(Content-Transfer-Encoding|content-transfer-encoding):"
        color header #c0a36e #1f1f28 "^(MIME-Version|mime-version):"

        # Spam / danger
        color header #e82424 #1f1f28 "^(X-Spam-Status|x-spam-status|X-SpamProbe|x-spamprobe):"
        color header #e82424 #1f1f28 "^(X-Spam-Flag|x-spam-flag):.*YES"
        color header #e82424 #1f1f28 "^(X-SpamProbe|x-spamprobe): SPAM"

        # Quoted text (7 levels)
        color quoted  #6a9589 #1f1f28
        color quoted1 #c0a36e #1f1f28
        color quoted2 #c34043 #1f1f28
        color quoted3 #76946a #1f1f28
        color quoted4 #6a9589 #1f1f28
        color quoted5 #c0a36e #1f1f28
        color quoted6 #c34043 #1f1f28
        color quoted7 #76946a #1f1f28

        # General UI
        color normal     #dcd7ba #1f1f28
        color indicator  #1f1f28 #6a9589          # selected line
        color status     #e6c384 #2a2a37          # status bar
        color tree       #7e9cd8 #1f1f28
        color attachment #1f1f28 #76946a
        color signature  #957fb8 #1f1f28
        color search     #1f1f28 #e6c384
        color error      #e82424 #1f1f28
        color message    #dcd7ba #1f1f28
        color tilde      #76946a #1f1f28
        color markers    #7aa89f #1f1f28
        color bold       #e6c384 #1f1f28
        color progress   #1f1f28 #7e9cd8

        # Optional: default header color (everything not matched above)
        color hdrdefault #dcd7ba #1f1f28

        # Mono fallbacks
        mono bold bold
        mono underline underline
        mono indicator reverse
      '';
    };
  };
}
