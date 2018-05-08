Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45302 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751533AbeEHVYK (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 May 2018 17:24:10 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v1 0/5] Enable holes on copy_file_range()
Date: Tue,  8 May 2018 16:24:01 -0500
Message-Id: <20180508212405.15297-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, david@fromorbit.com
List-ID: <linux-unionfs@vger.kernel.org>

If copy_file_range performs a copy using splice, it converts holes
to zeros. This effort primarily changes this behavior to create
holes when it is possible. 

Even if copy_file_range() or clone_file_range() does not work for different
mounted filesystems, We should be able to splice files if they do not
belong the same super_block.

Changes since v0:
- [Amir] Carved out do_copy_file_range() which can be used by overlayfs

-- 
Goldwyn

