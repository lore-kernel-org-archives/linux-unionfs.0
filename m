From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 3/5] vfs: wrap write f_ops with
        file_{start,end}_write()
Date: Tue, 31 Jan 2017 11:56:38 +0100
Message-ID: <20170131105638.GC2907@lst.de>
References: <1485851699-25313-1-git-send-email-amir73il@gmail.com> <1485851699-25313-4-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:55538 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751560AbdAaK4v (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jan 2017 05:56:51 -0500
Content-Disposition: inline
In-Reply-To: <1485851699-25313-4-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
