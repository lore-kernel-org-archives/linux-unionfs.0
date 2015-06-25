From: james harvey <jamespharvey20@gmail.com>
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
Date: Thu, 25 Jun 2015 16:59:33 -0400
Message-ID: <CA+X5Wn4Q5bOe0u2MFGo-mbrgLWgX0HGG41j5jU6qPeVxhc4PZg@mail.gmail.com>
References: <CA+X5Wn5P2pos=piiujkLHbYR7zCXiANuKrgPT1A1NuqLTh9qMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:36603 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbbFYU7f (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 25 Jun 2015 16:59:35 -0400
Received: by lacny3 with SMTP id ny3so52292719lac.3
        for <linux-unionfs@vger.kernel.org>; Thu, 25 Jun 2015 13:59:33 -0700 (PDT)
In-Reply-To: <CA+X5Wn5P2pos=piiujkLHbYR7zCXiANuKrgPT1A1NuqLTh9qMQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Particularly useful to avoid "Invalid cross-device link" when using cp
-ax, when source and dest are seen as different devices.

Such as if there is a top-level subvolume mounted as /, with others
mounted elsewhere.  Required workaround is to mount with subvolid=0 to
/mnt, cp -ax --reflink=always /mnt/...source /mnt/...dest

On Thu, Jun 25, 2015 at 4:47 PM, james harvey <jamespharvey20@gmail.com> wrote:
> Request for new btrfs subvolume subcommand:
>
> clone or fork [-i <qgroupid] <source> [<dest>]<name>
>    Create a subvolume <name> in <dest>, which is a clone or fork of source.
>    If <dest> is not given, subvolume <name> will be created in the
> current directory.
>    Options
>    -i <qgroupid>
>       Add the newly created subvolume to a qgroup.  This option can be
> given multiple times.
>
> Would (I think):
> * btrfs subvolume create <dest-subvolume>
> * cp -ax --reflink=always <source-subvolume>/* <dest-subvolume>/
