Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33052 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726024AbfLCNtw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Dec 2019 08:49:52 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 14DF8B123
        for <linux-unionfs@vger.kernel.org>; Tue,  3 Dec 2019 13:49:51 +0000 (UTC)
From: Fabian Vogt <fvogt@suse.de>
Subject: overlayfs does not pin underlying layers
Date: Tue, 03 Dec 2019 14:49:50 +0100
Message-ID: <7817498.QaoxCVBQX0@linux-e202.suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs <linux-unionfs@vger.kernel.org>
Cc: iforster@suse.de
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

I noticed that you can still unmount the lower/upper/work layers, even if
they're currently part of an active overlay mount. This is the case even when
files in the overlay mount are currently open. After unmounting, the usual
effects of a lazy umount can be observed, like still active loop devices.

Is this intentional? From a quick look, for open files this might be a side
effect of using open_with_fake_path, but just getting a reference to the paths
in ovl_mount_dir and preventing unmounting for the duration of the overlay
mount would cover that as well AFAICT.

Thanks,
Fabian

---< demo script >---

#!/bin/bash
set -euxo pipefail

tmpdir=$(mktemp -d)
trap "rm -rf $tmpdir" EXIT
mkdir ${tmpdir}/{lower,upper,work,mount}

# Create ext4 fs, mount as lower
dd if=/dev/zero of=${tmpdir}/fs.img bs=1M count=10
mkfs.ext4 -q ${tmpdir}/fs.img
mount ${tmpdir}/fs.img ${tmpdir}/lower

# Create a file
echo "This is in lower" > ${tmpdir}/lower/lowerfile

# Mount overlayfs
mount -t overlay overlay ${tmpdir}/mount -o lowerdir=${tmpdir}/lower,workdir=${tmpdir}/work,upperdir=${tmpdir}/upper

# Open the file and print its contentghzogo8ugz312 iutv123u1
exec 3<${tmpdir}/mount/lowerfile
cat <&3

# Umount the lower fs
umount ${tmpdir}/lower && echo "Lower successfully unmounted"

# Show that the overlay mount is still there
mountpoint -q ${tmpdir}/lower || echo "Lower is not mounted anymore"
mountpoint -q ${tmpdir}/mount && echo "Overlay still mounted"
cat ${tmpdir}/mount/lowerfile

# Clean up
exec 3<&-
umount ${tmpdir}/mount
