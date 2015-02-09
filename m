From: Eric Jones <ejones@cray.com>
Subject: Re: Support for filesystems with d_revalidate (NFS)
Date: Mon, 9 Feb 2015 13:12:25 -0800
Message-ID: <20150209211225.GJ32617@cray.com>
References: <E4C1F457-0D8A-4118-9F10-819D8CCA5ADE@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [68.232.143.164] ([68.232.143.164]:49538 "EHLO
	esa2.cray.iphmx.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbbBIV27 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 9 Feb 2015 16:28:59 -0500
Content-Disposition: inline
In-Reply-To: <E4C1F457-0D8A-4118-9F10-819D8CCA5ADE@ornl.gov>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "Caldwell, Blake A." <blakec@ornl.gov>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

I don't have an answer, but I'll note it worked at some point. For example, the overlayfs code in SuSE's SLES12 release allows it. I'm not sure why Novell merged such a different version of the overlayfs code.


On Mon, Feb 09, 2015 at 03:11:46PM +0000, Caldwell, Blake A. wrote:
> Hi there,
> 
> Is perhaps a fix for disabling overlayfsroot for filesystems with revalidate on the horizon? My use case for overlayfs is a NFS (v3 or v4) lowerdir, which appears rejected by the code below because NFS defines d_revalidate, d_automount, and d_weak_revalidate (v3 only).
> 
> There has been discussion in this launchpad bug about xattr copyup problems:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1039402
> 
> fs/overlayfs/super.c@692:
>        /*
>         * We don't support:
>         *  - automount filesystems
>         *  - filesystems with revalidate (FIXME for lower layer)
>         *  - filesystems with case insensitive names
>         */
>        if (dop &&
>            (dop->d_manage || dop->d_automount ||
>             dop->d_revalidate || dop->d_weak_revalidate ||
>             dop->d_compare || dop->d_hash)) {
>                return false;
>        }
> 
> Regarding the referenced code in overlayfs-next, is there a condition in which NFSv4 could be supported, such as if mounted read-only?
> 
> -Blake
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
