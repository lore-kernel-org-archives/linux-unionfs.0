From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 21 Nov 2016 10:54:41 +0100
Message-ID: <CAJfpegtZ_86Axi9Ffrdzhkgy9gvd-bUnWMXwhGo-LRAegTWd8w@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com> <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
 <20161107134215.2v5leafss2mamim5@home.ouaza.com> <CAJfpeguvHgWuefxfB76qPh8xGW74tuB1q3kgXvEBw5qY80xz-w@mail.gmail.com>
 <CAOQ4uxiC+O93=Dbgogc-GpL_7rF-qCRXeGzy3epVfpZRHNQf=A@mail.gmail.com>
 <CAOQ4uxjAZAWTy14B1HA-=RmPVsgBBXve7914g0gn7EG3xADebA@mail.gmail.com>
 <CAJfpegsKmo9zES6ZpHkjVE50z6ere3J9X2ixSFN6dhU_cEReSw@mail.gmail.com> <CAOQ4uxjD60ZqjXYq345SEjg79V89NvM8bUGt1=CUSiQHyQcBkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:36614 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752580AbcKUJyo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2016 04:54:44 -0500
Received: by mail-oi0-f51.google.com with SMTP id v84so154567644oie.3
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2016 01:54:43 -0800 (PST)
In-Reply-To: <CAOQ4uxjD60ZqjXYq345SEjg79V89NvM8bUGt1=CUSiQHyQcBkA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Raphael Hertzog <hertzog@debian.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Nov 18, 2016 at 4:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:

> Found one typo and one bug in error that can cause crash on dput(ERR_PTR(err)):

Thanks.

Fixes force pushed to overlayfs-next.

Also pushed the redirect patches to overlayfs-next, as they seem to
have matured enough.

Thanks,
Miklos
