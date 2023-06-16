Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5281EB64D7
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 07:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbjFPHGC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 03:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244987AbjFPHFL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 03:05:11 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F99930FB;
        Fri, 16 Jun 2023 00:04:51 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BDEEE6732D; Fri, 16 Jun 2023 09:04:47 +0200 (CEST)
Date:   Fri, 16 Jun 2023 09:04:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@lst.de>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v5 1/5] fs: rename {vfs,kernel}_tmpfile_open()
Message-ID: <20230616070447.GA29590@lst.de>
References: <20230615112229.2143178-1-amir73il@gmail.com> <20230615112229.2143178-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230615112229.2143178-2-amir73il@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jun 15, 2023 at 02:22:25PM +0300, Amir Goldstein wrote:
> Overlayfs and cachefiles use vfs_open_tmpfile() to open a tmpfile
> without accounting for nr_files.
> 
> Rename this helper to kernel_tmpfile_open() to better reflect this
> helper is used for kernel internal users.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

The subject is a little weird as it suggest you rename two things, but
except for that, this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
