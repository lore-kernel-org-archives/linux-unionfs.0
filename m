Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52936 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbeECP0k (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 May 2018 11:26:40 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 0/3] Holey splice! copy_file_range() with holes
Date: Thu,  3 May 2018 10:26:32 -0500
Message-Id: <20180503152635.14974-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, Anna.Schumaker@Netapp.com, darrick.wong@oracle.com
List-ID: <linux-unionfs@vger.kernel.org>

If copy_file_range performs a copy using splice, it converts holes
to zeros. This effort primarily changes this behavior to create
holes when it is possible. I am not sure if we should put it under
a flag, but I think this should be the default behavior as opposed
to converting holes to allocated zeros. We can use a flag to instruct
copy_file_range() to convert holes to allocated zeros. Let me know..

We should be able to splice files if they do not belong the same
super_block.

overlay copy_up can benefit from this.

This could make it ready for coreutils/cp to use copy_file_range(),
primarily to deal with --sparse=WHEN option.

-- 
Goldwyn

