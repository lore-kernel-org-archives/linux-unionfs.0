From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH] ovl: don't follow redirects if redirect_dir=off
Date: Tue, 5 Dec 2017 16:19:06 +0100
Message-ID: <CAJfpegug+zPTOx8p=ayzK_qc1f_qdXmtpHGA2hOzNL2QrQVPug@mail.gmail.com>
References: <20171205133707.GA24303@veci.piliscsaba.redhat.com> <CAOQ4uxjenDTNxj_pQ-9UTw9sVeGmFuKh895GNKANb+EK5yVb1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:41644 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752579AbdLEPTH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Dec 2017 10:19:07 -0500
Received: by mail-qt0-f194.google.com with SMTP id i40so1466984qti.8
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Dec 2017 07:19:07 -0800 (PST)
In-Reply-To: <CAOQ4uxjenDTNxj_pQ-9UTw9sVeGmFuKh895GNKANb+EK5yVb1A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Dec 5, 2017 at 4:01 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Dec 5, 2017 at 3:37 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> Overlayfs is following redirects even when redirects are disabled. If this
>> is unintentional (probably the majority of cases) then this can be a
>> problem.  E.g. upper layer comes from untrusted USB drive, and attacker
>> crafts a redirect to enable read access to otherwise unreadable
>> directories.
>>
>> If "redirect=off", then turn off following as well as creation of
>> redirects.  If "redirect=follow", then turn on following, but turn off
>> creation of redirects (which is what "redirect=off" does now).
>>
>> This is a backward incompatible change, so make it dependent on a config
>> option.
>>
>> Reported-by: David Howells <dhowells@redhat.com>
>> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>> ---
> [...]
>>  static bool ovl_index_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX);
>>  module_param_named(index, ovl_index_def, bool, 0644);
>>  MODULE_PARM_DESC(ovl_index_def,
>> @@ -315,7 +318,8 @@ static int ovl_show_options(struct seq_f
>>                 seq_puts(m, ",default_permissions");
>>         if (ofs->config.redirect_dir != ovl_redirect_dir_def)
>>                 seq_printf(m, ",redirect_dir=%s",
>> -                          ofs->config.redirect_dir ? "on" : "off");
>> +                          ofs->config.redirect_dir ? "on" :
>> +                          (ofs->config.redirect_follow ? "follow" : "off"));
>
>
> ovl_show_options() not reflecting mount options in several cases, for example:
> ofs->config.redirect_dir == ovl_redirect_dir_def &&
> !ovl_redirect_dir_def &&  !ovl_redirect_follow_def &&
> ofs->config.redirect_follow
> doesn't show "redirect_dir=follow" after user mounted with "-o
> redirect_dir=follow"
>
> Another anomaly is with (ovl_redirect_dir_def && ovl_redirect_follow_def)
> when user mounts with "-o redirect_dir=off", but /proc/mounts will show
> "redirect_dir=follow".
>
> I guess that last one may be justified, but maybe requires a pr_info() on mount
> to notify user that redirect_dir follow is always enabled even on
> redirect_dir=off,
> but the first one is just a bug.

Indeed, well spotted.

Thanks,
Miklos
