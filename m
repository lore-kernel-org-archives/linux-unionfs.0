From: "Caldwell, Blake A." <blakec@ornl.gov>
Subject: Support for filesystems with d_revalidate (NFS)
Date: Mon, 9 Feb 2015 15:11:46 +0000
Message-ID: <E4C1F457-0D8A-4118-9F10-819D8CCA5ADE@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mta01.ornl.gov ([128.219.177.14]:10364 "EHLO mta01.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759816AbbBIPVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 9 Feb 2015 10:21:25 -0500
Received: from EXCHCS32.ornl.gov (exchcs32.ornl.gov [128.219.12.146])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	by emgwy1.ornl.gov (Postfix) with ESMTPS id 3CE0D100652
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Feb 2015 10:11:49 -0500 (EST)
Content-Language: en-US
Content-ID: <E0039F2F6C3AE24B8A24F1DCD278E5EE@ornl.gov>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

Hi there,

Is perhaps a fix for disabling overlayfsroot for filesystems with revalidate on the horizon? My use case for overlayfs is a NFS (v3 or v4) lowerdir, which appears rejected by the code below because NFS defines d_revalidate, d_automount, and d_weak_revalidate (v3 only).

There has been discussion in this launchpad bug about xattr copyup problems:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1039402

fs/overlayfs/super.c@692:
       /*
        * We don't support:
        *  - automount filesystems
        *  - filesystems with revalidate (FIXME for lower layer)
        *  - filesystems with case insensitive names
        */
       if (dop &&
           (dop->d_manage || dop->d_automount ||
            dop->d_revalidate || dop->d_weak_revalidate ||
            dop->d_compare || dop->d_hash)) {
               return false;
       }

Regarding the referenced code in overlayfs-next, is there a condition in which NFSv4 could be supported, such as if mounted read-only?

-Blake
