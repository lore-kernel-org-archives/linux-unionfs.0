Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754070AbeENO4l (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 14 May 2018 10:56:41 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v3 0/4] Enable holes in copy_file_range()
Date: Mon, 14 May 2018 09:56:33 -0500
Message-Id: <20180514145637.22711-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, linux-unionfs@vger.kernel.org, david@fromorbit.com, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

If copy_file_range performs a copy using splice, it converts holes
to zeros. This effort primarily changes this behavior to create
holes when it is possible. 

Even if copy_file_range() or clone_file_range() does not work for different
mounted filesystems, We should be able to splice files if they do not
belong the same super_block.

Testing:
I ran fstests, especially generic/43[0-4] and the overlayfs tests.
Besides also created new tests, however, it is waiitng on xfs_io fix
for copy_range. I shall post the new test which deals with holes shortly.

Changes since v2:
- Added size check so it does not punch a zero size hole

Changes since v1:
- Fixed bug when hole/data offset is farther than len
- [Amir] Refactor flags parameter

Changes since v0:
- [Amir] Carved out do_copy_file_range() which can be used by overlayfs

-- 
Goldwyn

