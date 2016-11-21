From: Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 3/3] ovl: redirect on rename-dir
Date: Mon, 21 Nov 2016 11:16:49 +0100
Message-ID: <CAOssrKe=5sRj1NeUeNnD3r8_2D6yG1modqobn67D-0Wj52Ju3g@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
 <1477380887-21333-4-git-send-email-mszeredi@redhat.com> <20161025115748.ydhkkp5cfcdnjzwn@home.ouaza.com>
 <CAJfpegu97ce6LtMeKSHqDxZGAtCJUGgYUwOwYm9P6p8XtNXf_A@mail.gmail.com>
 <CALYGNiN_Hj+4Kf4HJihu5OEkNFU+zzioz5Cc1oHpJ8Wggi0M8Q@mail.gmail.com>
 <20161107110319.7goz3ym3e6fu5lag@home.ouaza.com> <CALYGNiP=BjxrU9YLL=bGJ5yXSefGMWEAU8ni23mUipL3frjhzA@mail.gmail.com>
 <20161107134215.2v5leafss2mamim5@home.ouaza.com> <CAJfpeguvHgWuefxfB76qPh8xGW74tuB1q3kgXvEBw5qY80xz-w@mail.gmail.com>
 <CAOQ4uxiC+O93=Dbgogc-GpL_7rF-qCRXeGzy3epVfpZRHNQf=A@mail.gmail.com>
 <CAOQ4uxjAZAWTy14B1HA-=RmPVsgBBXve7914g0gn7EG3xADebA@mail.gmail.com>
 <CAJfpegsKmo9zES6ZpHkjVE50z6ere3J9X2ixSFN6dhU_cEReSw@mail.gmail.com>
 <CAOQ4uxjD60ZqjXYq345SEjg79V89NvM8bUGt1=CUSiQHyQcBkA@mail.gmail.com>
 <CAJfpegtZ_86Axi9Ffrdzhkgy9gvd-bUnWMXwhGo-LRAegTWd8w@mail.gmail.com> <CAOQ4uxh0eqgMezo1zUhdvKNXYofb_-fpV_ASO-A7vJOWXnZ0Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35683 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753607AbcKUKQw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2016 05:16:52 -0500
Received: by mail-wm0-f54.google.com with SMTP id a197so137570964wmd.0
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2016 02:16:51 -0800 (PST)
In-Reply-To: <CAOQ4uxh0eqgMezo1zUhdvKNXYofb_-fpV_ASO-A7vJOWXnZ0Kg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Raphael Hertzog <hertzog@debian.org>, Konstantin Khlebnikov <koct9i@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Guillem Jover <guillem@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Mon, Nov 21, 2016 at 11:13 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Nov 21, 2016 at 11:54 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Fri, Nov 18, 2016 at 4:37 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>>> Found one typo and one bug in error that can cause crash on dput(ERR_PTR(err)):
>>
>> Thanks.
>>
>> Fixes force pushed to overlayfs-next.
>
> All right. I had the (wrong) impression the next was not a rewindable branch.

That depends on how many devel branches are broken by such an action.
In case of overlayfs-next, there doesn't appear to be too much of
that, so for now I feel free to mess with it.

Thanks,
Miklos
