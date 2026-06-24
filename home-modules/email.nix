{ config, options, lib, pkgs, ... }:
let
  accountFilename = account: config.xdg.configHome + "/neomutt/" + account.name;
  cfg = config.dotfiles.email;
in
{
  options.dotfiles.email = with lib; {
    enable = mkEnableOption "email";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.w3m ];

    xdg.configFile.".mailcap".text = ''
      text/*; nvim -R %s; needsterminal
      text/html; w3m -dump %s; needsterminal; copiousoutput
    '';
    programs.neomutt = {
      enable = true;
      extraConfig = ''
        set pgp_default_key = E8A7BB8D37C341113C3DCAD8853206476F1DF5A1
        set pgp_sign_as = 0x7239FA16084C3CAD
        set hidden_host
        set abort_nosubject
        set status_on_top
        set menu_move_off = no
        set menu_scroll = no

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

        unbind index c
        macro index 'cc' '<change-folder>'

        bind attach <return> view-mailcap

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


        # Colors
        #--------------------------------------------------------------------------

        # Colours for items in the index
        color index brightcyan black ~N
        #color index brightgreen black "~N (~x byers.world)|(~x byers.x)|(~x langly.levallois123.axialys.net)|(~x the.earth.li)"
        color index brightyellow black ~F
        color index black green ~T
        color index brightred black ~D
        mono index bold ~N
        mono index bold ~F
        mono index bold ~T
        mono index bold ~D

        # Highlights inside the body of a message.

        # URLs
        color body brightgreen black "(http|ftp|news|telnet|finger)://[^ \"\t\r\n]*"
        color body brightgreen black "mailto:[-a-z_0-9.]+@[-a-z_0-9.]+"
        mono body bold "(http|ftp|news|telnet|finger)://[^ \"\t\r\n]*"
        mono body bold "mailto:[-a-z_0-9.]+@[-a-z_0-9.]+"

        # email addresses
        color body brightgreen black "[-a-z_0-9.%$]+@[-a-z_0-9.]+\\.[-a-z][-a-z]+"
        #mono body bold "[-a-z_0-9.%$]+@[-a-z_0-9.]+\\.[-a-z][-a-z]+"

        # header
        color header green black "^from:"
        color header green black "^to:"
        color header green black "^cc:"
        color header green black "^date:"
        color header yellow black "^newsgroups:"
        color header yellow black "^reply-to:"
        color header brightcyan black "^subject:"
        color header red black "^x-spam-rule:"
        color header green black "^x-mailer:"
        color header yellow black "^message-id:"
        color header yellow black "^Organization:"
        color header yellow black "^Organisation:"
        color header yellow black "^User-Agent:"
        color header yellow black "^message-id: .*pine"
        color header yellow black "^X-Fnord:"
        color header yellow black "^X-WebTV-Stationery:"
        color header yellow black "^X-Message-Flag:"
        color header yellow black "^X-Spam-Status:"
        color header yellow black "^X-SpamProbe:"
        color header red black "^X-SpamProbe: SPAM"


        # Coloring quoted text - coloring the first 7 levels:
        color quoted cyan black
        color quoted1 yellow black
        color quoted2 red black
        color quoted3 green black
        color quoted4 cyan black
        color quoted5 yellow black
        color quoted6 red black
        color quoted7 green black


        # Default color definitions
        #color hdrdefault white green
        color signature brightmagenta black
        color indicator black cyan
        color attachment black green
        color error red black
        color message white black
        color search brightwhite magenta
        color status brightyellow blue
        color tree brightblue black
        color normal white black
        color tilde green black
        color bold brightyellow black
        #color underline magenta black
        color markers brightcyan black
        # Colour definitions when on a mono screen
        mono bold bold
        mono underline underline
        mono indicator reverse
      '';
    };
  };
}
