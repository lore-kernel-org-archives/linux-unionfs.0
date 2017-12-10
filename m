From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC PATCH v2] ovl: don't follow redirects if redirect_dir=off
Date: Sun, 10 Dec 2017 08:29:11 +0200
Message-ID: <CAOQ4uxj0wXKbUZ2m=rH=89w+ZP_vibCH_ND2saC05kt19ApcxA@mail.gmail.com>
References: <20171206150333.GB24303@veci.piliscsaba.redhat.com> <30533.1512743808@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:36000 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbdLJG3M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 10 Dec 2017 01:29:12 -0500
Received: by mail-yw0-f174.google.com with SMTP id r205so6582566ywb.3
        for <linux-unionfs@vger.kernel.org>; Sat, 09 Dec 2017 22:29:12 -0800 (PST)
In-Reply-To: <30533.1512743808@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Fri, Dec 8, 2017 at 4:36 PM, David Howells <dhowells@redhat.com> wrote:
> Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> +     const char *redirect_mode;
>> ...
>> +     kfree(ofs->config.redirect_mode);
>
> That's going to get you a compiler warning under some circumstances.
>
>> +                     config->redirect_mode = match_strdup(&args[0]);
>
> We shouldn't really be copying the string if we can help it, though I grant we
> may not have the match_*() function to do otherwise at the moment.  I would
> much prefer seeing it rendered to an enum value at this point.
>

If we store config->redirect_mode as bitmask, then it would be nicer
for testing redirect/follow independently as Miklos wanted and it would
be still nice for checking if mode is not the default, i.e.:

#define OVL_REDIRECT_DIR 0x1 /* flag casted from bool ovl_redirect_dir_def */
#define OVL_REDIRECT_FOLLOW 0x2

       if (ofs->config.redirect_mode != (unsigned) ovl_redirect_dir_def)
               seq_printf(m, ",redirect_dir=%s", ovl_redirect_mode_str(ofs));


Amir.
