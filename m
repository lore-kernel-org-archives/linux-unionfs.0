From: Vito Caputo <vito.caputo@coreos.com>
Subject: Re: [PATCH] overlayfs: Make dir inode always point to the underlay
Date: Mon, 15 Aug 2016 17:14:31 -0700
Message-ID: <CAKp8XJ413FtvzCSvCQBbwwwvkF0Kz9mWj31X3igk66oVn-1yoQ@mail.gmail.com>
References: <4b4580e4-8bec-bfba-cd94-1d531a2f06cc@yunify.com> <20160815090815.GH25404@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33686 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbcHPAOd (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 15 Aug 2016 20:14:33 -0400
Received: by mail-io0-f181.google.com with SMTP id 38so93787887iol.0
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Aug 2016 17:14:32 -0700 (PDT)
In-Reply-To: <20160815090815.GH25404@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: oc <oc@yunify.com>, linux-unionfs@vger.kernel.org, dhowells@redhat.com, trivial@kernel.org

Miklos,

Sure, I think the approach of returning the lower layer's ino/dev
combination for merged directories should be ok?

I guess the one somewhat unexpected behavior/potential down side is
st_dev spuriously being different within an overlayfs mount point,
things like `find -xdev` or `du -x` won't recurse into directories on
the upper layer.  The advantage of the copying up the directory on
getattr was it gave all the directories in the overlay unique inode
numbers within a single device.

Regards,
Vito Caputo

On Mon, Aug 15, 2016 at 2:08 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> [This is *far* from being a trivial patch,  please don't treat it as such]
>
> On Fri, Aug 12, 2016 at 03:34:51PM +0800, oc wrote:
>> Since file inode points to the underlay from ovl_path_real method, the dir
>> inode should also point to the one from underlay. This issue introduced
>> problem when live migrates a container instance using criu, which need to
>> convert inotify inode entry to file path, because inotify point to the real
>> inode in underlay.
>
> Not quite sure what the problem is here.  It is true that inotify is currently
> broken.  There's a fix pending for that here:
>
>   https://git.kernel.org/cgit/linux/kernel/git/mszeredi/vfs.git/commit/?h=overlayfs-next&id=09557932babf3462125749212bc1cde574404fbb
>
> There's also an issue with inode numbers being unstable for directories:
>
>   http://marc.info/?t=146914417200002&r=1&w=2
>
> As explained in that thread the problem with always using the underlying
> inode/dev is that it makes the inode number change when the directory is copied
> up.
>
> So there are multiple, somewhat conflicting requirements here and it would be
> good to have a solution that everyone is happy with and is unlikely to break
> existing setups.
>
> Does the last patch in the above thread work for you?
>
> And what about if you additionally do
>
> -stat->dev = lowerstat.dev;
> +stat->dev = dentry->d_sb->s_dev;
>
> ?
>
> Vito, could you also please supply feedback on those patches?
>
> Thanks,
> Miklos
