From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: How to specify the mount points for multiple lower layers?
Date: Wed, 12 Aug 2015 11:39:57 +0200
Message-ID: <CAJfpegsDUDtRS81d+8e_+WQewvnZoRQ4Mfpw0qFDkdiUFe140w@mail.gmail.com>
References: <55C319EC.4080707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33203 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbbHLJj6 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 12 Aug 2015 05:39:58 -0400
Received: by obbhe7 with SMTP id he7so8614994obb.0
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Aug 2015 02:39:58 -0700 (PDT)
In-Reply-To: <55C319EC.4080707@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alkis Georgopoulos <alkisg@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Thu, Aug 6, 2015 at 10:25 AM, Alkis Georgopoulos <alkisg@gmail.com> wrote:
> From https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt:
> mount -t overlay overlay -olowerdir=/lower1:/lower2:/lower3 /merged
>
> How can I specify that I want e.g. lower2 to be mounted at merged/home?
>
> If all lower* layers can only be mounted at /merged, then I don't see any
> way at all that overlayfs would allow me to combine e.g.
> Partition  MountDir  MergedDir
> ------------------------------
> /dev/sda1  /root-fs  /merged
> /dev/sda2  /home-fs  /merged/home
>
> I even tried to create a fake directory structure like this:
> /dev/sda2 /fakedir/home /merged
> ...so that I would mount /dev/sda2 to /fakedir/home, and then try to use
> lower2=/fakedir, but then I got a different issue, that overlayfs doesn't
> include submounts, so sda2 wasn't visible at all then.
>
> So I was unable to combine the root and home partitions to the correct paths
> using overlayfs (I'm planning to use a tmpfs as the upper dir later on).
>
> Any help? Thank you!

Create two overlays: one for root and one for home (which includes the
additional home-fs).

Does that work for you?

Thanks,
Miklos
