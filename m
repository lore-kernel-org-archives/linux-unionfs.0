Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756118AbeEJB6Z (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 May 2018 21:58:25 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v2 0/4] Enable holes in copy_file_range()
Date: Wed,  9 May 2018 20:58:16 -0500
Message-Id: <20180510015820.17700-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, linux-unionfs@vger.kernel.org, david@fromorbit.com, viro@zeniv.linux.org.uk
List-ID: <linux-unionfs@vger.kernel.org>

If copy_file_range performs a copy using splice, it converts holes
to zeros. This effort primarily changes this behavior to create
holes when it is possible. 

Even if copy_file_range() or clone_file_range() does not work for different
mounted filesystems, We should be able to splice files if they do not
belong the same super_block.

Changes since v1:
- Fixed bug when hole/data offset is farther than len
- [Amir] Refactor flags parameter

Changes since v0:
- [Amir] Carved out do_copy_file_range() which can be used by overlayfs

-- 
Goldwyn

