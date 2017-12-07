From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH v2] ovl: don't follow redirects if redirect_dir=off
Date: Thu, 7 Dec 2017 10:25:28 +0100
Message-ID: <CAJfpegu6AZE5M3OP=4r8j=+d8ddWkENfF1OJjJetxw31e4ExOA@mail.gmail.com>
References: <20171206150333.GB24303@veci.piliscsaba.redhat.com> <CAOQ4uxhx9ZefiWCM4JyBckeuB6GqvOd3BV8KmGCiDk9Bsf11QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:33667 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752550AbdLGJZ3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 04:25:29 -0500
Received: by mail-qt0-f178.google.com with SMTP id e2so15910524qti.0
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Dec 2017 01:25:29 -0800 (PST)
In-Reply-To: <CAOQ4uxhx9ZefiWCM4JyBckeuB6GqvOd3BV8KmGCiDk9Bsf11QQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Dec 6, 2017 at 5:33 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Dec 6, 2017 at 5:03 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:

>> --- a/fs/overlayfs/ovl_entry.h
>> +++ b/fs/overlayfs/ovl_entry.h
>> @@ -14,6 +14,8 @@ struct ovl_config {
>>         char *workdir;
>>         bool default_permissions;
>>         bool redirect_dir;
>> +       bool redirect_follow;
>
> IMO the configuration modes would be better describes by:
>
> enum ovl_redirect {
>    OVL_REDIRECT_OFF,
>    OVL_REDIRECT_FOLLOW,
>    OVL_REDIRECT_ON,
> }
>
> Making the combination (!redirect_follow && redirect_dir) impossible
>
> instead of testing ofs->config.redirect_follow, can test
> ofs->config.redirect >= OVL_REDIRECT_FOLLOW

This is less readable, IMO.  While it doesn't make any sense to create
without follow, these two are in fact two separate functions, and
having two bools for them is fine.   The cost is one more line while
parsing, which enforces sanity for setting these flags.

Other comments fixed.  Thanks for the review.

Thanks,
Miklos
