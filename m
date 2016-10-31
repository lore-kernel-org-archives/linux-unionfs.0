From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 31 Oct 2016 17:02:36 +0200
Message-ID: <CAOQ4uxj-h4AdFSr9Ve-Wp4nKdj+r41aJe++RXyHuVo+C7YgqzQ@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <CAOQ4uxhTOw9vHVSQURakYgamXMxXDTnZYFjUDZYx1Hnf=TA9dA@mail.gmail.com>
 <CAJfpegs+NDycOda67y5-8zDYHk90gxdQuQsRQ2pLq58UcUqa9A@mail.gmail.com>
 <CAOQ4uxgqGkioGZ9=rG3+m-SQEBCGH-9zvsC0-+KtRP0yuL0jRQ@mail.gmail.com> <CAOssrKdfoffq2AZvYkDY1gkYbmj=BJ=-jaqGx3v1ReAfBgf6ug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34614 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943732AbcJaPCj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 31 Oct 2016 11:02:39 -0400
In-Reply-To: <CAOssrKdfoffq2AZvYkDY1gkYbmj=BJ=-jaqGx3v1ReAfBgf6ug@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Oct 31, 2016 at 4:59 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> On Sun, Oct 30, 2016 at 11:00 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> I have a POC for generic addition of layers for unionmount-testsuite
>> I pushed it to my github:
>> https://github.com/amir73il/unionmount-testsuite.git #ovl_rename_dir
>
> Cool.  But... this seems to be missing the "remount_union" module.

Doh! fixes and force pushed

>
> Thanks,
> Miklos
