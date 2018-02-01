From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [QUESTION] problem about origin xattr
Date: Thu, 1 Feb 2018 10:25:43 -0500
Message-ID: <20180201152543.GA12648@redhat.com>
References: <20180131165522.GD8087@redhat.com>
 <CAJfpegsWhJJdVKi+ZW+5MoYeo87xwtn27sZ2xjExL8-Qk8BPSA@mail.gmail.com>
 <20180131190503.GA2699@redhat.com>
 <CAOQ4uxghhXgtXSwKN2nGUGEtoB42GtT0fboc5MxT4ieZ2-rbnw@mail.gmail.com>
 <20180131203438.GB2699@redhat.com>
 <CAJfpegtd_qP7FmKuad5=6kmJeBvz8YmwgA7AS8rhU+D3vgaX3g@mail.gmail.com>
 <20180131205807.GA11643@redhat.com>
 <CAJfpeguaEdLEkRtMBoQkAHtis0LChEAaOTcU0xvzMb=kAQ-aWg@mail.gmail.com>
 <20180131211223.GB11643@redhat.com>
 <CAOQ4uxjxKjwjmJmHJPJfjHvkokVd0_4r5ENLXcs-8VnQ4eBBBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbeBAPZo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Feb 2018 10:25:44 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjxKjwjmJmHJPJfjHvkokVd0_4r5ENLXcs-8VnQ4eBBBQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, yangerkun <yangerkun@huawei.com>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Feb 01, 2018 at 01:26:58AM +0200, Amir Goldstein wrote:

[..]
> >> >> > ORIGIN vs REDIRECT seems to be the only major sticking point w.r.t
> >> >> > these patches at this point of time. As long as you and miklos agree
> >> >> > on that semantics, things will be fine.
> >> >>
> >> >> I think there are many problems with using ORIGIN for data.
> >> >>
> >> >> I also think it should not be difficult to generalize the REDIRECT
> >> >> code from directory to regular file.  It should just be adding more
> >> >> conditions to create and handle redirects, no?  The actual code is
> >> >> already there, because we do it for directories.
> >> >
> >> > I guess so. We already are doing it for directories so we should be
> >> > able to extend it for regular files too. I don't know enough to be
> >> > able to say what affect this will have on performance.
> >> >
> >> >>
> >> >> So what's the issue with lowerstack[0]?  Can't we just use the same
> >> >> object for both purposes (i.e. the one found by going down the stack,
> >> >> just like for directories)?
> >> >
> >> > I think we should be able to. But then it seems to make ORIGIN redundant.
> >> > Because currently we are using ORIGIN to retrieve lowerstack[0]. And if
> >> > we change that, that means I will have to rip out ORIGIN logic altogether.
> >> > Its a relatively bigger change. So wanted to figure out is that what
> >> > we are looking for.
> >>
> >> Don't rip out ORIGIN logic, just disable it when we find METACOPY.
> >>
> >> So logic should be:
> >>
> >>  - check METACOPY xattr, if exists continue to lower layers just like
> >> non-opaque directory
> >>  - otherwise use ORIGIN xattr, just like we used to
> 
> Careful there, when following metacopy by path, you also need to apply
> ovl_verify_lower() logic for indexed files, i.e. all files with nfs_export
> and lower hardlinks with index=on. same as I did for merge dir lookup
> with nfs_export.

Hmm..., so for metacopy files, if ORIGIN fh does not match the lower found
in lowerstack[0] what do we do. Return -ESTALE?

Vivek
