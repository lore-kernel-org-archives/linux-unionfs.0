Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055D941F7C3
	for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2026 09:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790069251; cv=none; b=h9sOS02FVyPNKP1ewd//Xe9l549nezpLw9CFydkGez496PJmzzvWB4bfUbl2xidByyXs5BVspxh9R1b93zDJuvwX22xYhM/g0DanXXcHeRcPfp+qbjMfo8biQVIGvdP7XGTNVeVzvnsE3eTuKHHKs5r3C5v95qpHs8cC6wzvA48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790069251; c=relaxed/simple;
	bh=xRlpFE9yCrbEDclD4XOX7dIOGv9RBbAZvT/j0am3oH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RT8cLXXPQco2FW00+4yPgK5bvPM3KofsOVyQW8y8txqZPfI97tQsmtPhYIMUiAf8lMSkA74XVLpsUdIPRvznxZMft4zUi1bZXOSpJUCYaWE6BoS0235N4bbT5W9TLrJ+AaB9UwHufJmerWzyDvRTSRHAjCw8N4JzCICzwGcZZPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bebm+RMa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DWA6tMXT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bebm+RMa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DWA6tMXT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790069247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AhIe1Z57w2l/HJoSK8VK6KQJtUlMI8/EsSSaoJvVLck=;
	b=bebm+RMaBvpcQizaT1/l2uhfzZRoOZ2p2SmT0hzPSPwdh6D4b8MMzl385DGZbDO2J4djUg
	PM79jv+2mjF5Up8n5ZCqCtQJ5K6BFhCFsUHgBFsnoQI7n4OZxZRqNab+IKFaFqruwtEJg+
	w0SxrKzbdAU1VABysNNo8QHO3azWx58=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-267-1HeHW1ScP6qtJohb77pbQw-1; Tue, 22 Sep 2026 05:27:26 -0400
X-MC-Unique: 1HeHW1ScP6qtJohb77pbQw-1
X-Mimecast-MFC-AGG-ID: 1HeHW1ScP6qtJohb77pbQw_1790069245
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e6862e924so28981005e9.0
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Sep 2026 02:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790069245; x=1790674045; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AhIe1Z57w2l/HJoSK8VK6KQJtUlMI8/EsSSaoJvVLck=;
        b=DWA6tMXTAubD96xrjLjQ13JdM1v/VqbCblAtVGe9reWbIY92HUOPXiTHiQQgcZQdjH
         THjz9reaepazl2VGjGy/fd9kWVVS2JmB3waarkb1aGBXJSaPNPYXbzM/ujnnyduhusxd
         JBa7HMIbcLxagaqtKg1VLyJEf80+uQu/5zm3dBLFT7EcKhzCAn1O836uIObblhuR62YO
         4bRTXYy80yBKg9ePx0CQzpKXb7CmXptizMKD550bAPySYyPY+SgooBd4oRRZrvpFGxbP
         E4gjvD9hPO+digKfmIThuokSa/3GEzBW7MdD9zERMw2CkHLgtbliPvCSKhiK9GCrpKkf
         Rneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790069245; x=1790674045;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AhIe1Z57w2l/HJoSK8VK6KQJtUlMI8/EsSSaoJvVLck=;
        b=uLvafA6lwo/x5DX+S2NCOB4mV7xxf//xxzon1xdFmr4z/9pG88HqMTdeQKc5MXmjUj
         EL41ARzQi+QqiAEgt3k1PF4XAAOa1U6tDvPXDFFsT6ZfqGPtW5VbPMSAzIHLnQ4qsnlr
         XrwU0QI6NaeSh6fTRwEg4bPEvmZgFJ2f4JO03rngihwCAO0ehcfZWSqoNaEGjqPAUtqu
         I6NbpHwhwxrHrnEKJNxowNmIufgZrrRERSDprdkST1sYK71bmZ7oU9To5M6Bazo4v0JE
         hY+n3fcSY47+589GFJB0Gb9W4Hs5IAQ6n7BDa716b/l+H9C6eshAW3uhg3IVeAbC2O18
         Mi5w==
X-Forwarded-Encrypted: i=1; AKwUvBxSI3S2gO8+1ANOEkebYZ7COxIzPxsvzsV9Tdb0nMg4+gfIWbBAffEfwTvHCh7E2W3xriqr0B3cTBmKQijY@vger.kernel.org
X-Gm-Message-State: AFuF++kLjYrZpQWt2nNdzwfwGQagxCAPC3wbp4CbZklGRA96kq3rFdra
	qU5kMorDlkNF/uh6Z5Ap5lkwmHmMKfgaI3QwGu9rJlJAw9+gdmikvy+AVp7ESafREa7XptXR0S8
	nUzaHfrWsVqjMNlpnBuLjQZNMhc1i0Cz3xmZxSi+0Zd+mxUVkyEUnChCgQ25tsTMHBQ==
X-Gm-Gg: AYBFou292zMekVr+JK1wSsqu6QKK3zlGY4VFol7tgZehfyEmLedw/oKSrNbd2jZrR2+
	JPj5vPLvjoVCndUjsNSuONkIvrzPOhD6OpRrlCxIv9U/qAu2VKq6BVJEIVmgHXMk+ke3tyWeC23
	AZzwh+Z/RKNPoUUvn4FqZzZt4oD/WAS/gbuuedHEBQnm4ZgDUFLurEbKi/hi3D0XGjFIATmoYyf
	5aUpdmYEUn3mIr8/1z95m/e2NpMgG0gV+K9ig28/17ZQTTQBG8m0MlVmbv4s8jr90h9RD5uinOC
	49EiEfgDJoqjtI6xEBGZSzmBH/3Yv+EhpIAbP5h7iPvmEOYv+Mqldtbva/0dTUOkTo/BnT1oED8
	BNPvwdi485CCIeZ+S04H8B5+ZUP2+h9t27Q==
X-Received: by 2002:a05:600c:3b8a:b0:49d:1d6a:4cfb with SMTP id 5b1f17b1804b1-49fc56db759mr251806695e9.1.1790069245081;
        Tue, 22 Sep 2026 02:27:25 -0700 (PDT)
X-Received: by 2002:a05:600c:3b8a:b0:49d:1d6a:4cfb with SMTP id 5b1f17b1804b1-49fc56db759mr251806285e9.1.1790069244518;
        Tue, 22 Sep 2026 02:27:24 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fda8f04f7sm59590685e9.0.2026.09.22.02.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 02:27:24 -0700 (PDT)
Date: Tue, 22 Sep 2026 11:27:23 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, ebiggers@kernel.org, 
	hch@lst.de, Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 15/21] xfs: add fs-verity support
Message-ID: <arJHLT1tuHCxZqkR@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-16-aalbersh@kernel.org>
 <20260922044559.GO2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922044559.GO2705364@frogsfrogsfrogs>

On 2026-09-21 21:45:59, Darrick J. Wong wrote:
> On Fri, Sep 18, 2026 at 01:15:27PM +0200, Andrey Albershteyn wrote:
> > Add integration with fs-verity. XFS stores fs-verity descriptor and
> > Merkle tree in the inode data fork at first block aligned to 64k past
> > EOF.
> > 
> > The Merkle tree reading/writing is done through iomap interface. The
> > data itself is read to the inode's page cache. When XFS reads from this
> > region iomap doesn't call into fsverity to verify it against Merkle
> > tree. For data, verification is done at ioend completion in a workqueue.
> > 
> > When fs-verity is enabled on an inode, the XFS_IVERITY_CONSTRUCTION
> > flag is set meaning that the Merkle tree is being build. The
> > initialization ends with storing of verity descriptor and setting
> > inode on-disk flag (XFS_DIFLAG2_VERITY). Lastly, the
> > XFS_IVERITY_CONSTRUCTION is dropped and I_VERITY is set on inode.
> > 
> > The descriptor is stored in a new block aligned to 64k after the last
> > Merkle tree block. The size of the descriptor is stored at the end of
> > the last descriptor block (descriptor can be multiple blocks).
> > 
> > Pro-actively remove any unwritten extents as we use last extent to
> > locate descriptor.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_fsverity.c | 363 +++++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/xfs_fsverity.h |   2 +
> >  fs/xfs/xfs_message.c  |   4 +
> >  fs/xfs/xfs_message.h  |   1 +
> >  fs/xfs/xfs_mount.h    |   2 +
> >  fs/xfs/xfs_super.c    |   7 +
> >  6 files changed, 378 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
> > index 525855fdd30d..e62c9a5d0e1d 100644
> > --- a/fs/xfs/xfs_fsverity.c
> > +++ b/fs/xfs/xfs_fsverity.c
> > @@ -6,13 +6,22 @@
> >  #include "xfs_fs.h"
> >  #include "xfs_shared.h"
> >  #include "xfs_format.h"
> > -#include "xfs_log_format.h"
> >  #include "xfs_trans_resv.h"
> >  #include "xfs_mount.h"
> >  #include "xfs_inode.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_trace.h"
> > +#include "xfs_quota.h"
> >  #include "xfs_fsverity.h"
> > +#include "xfs_iomap.h"
> > +#include "xfs_error.h"
> > +#include "xfs_health.h"
> > +#include "xfs_bmap_util.h"
> > +#include "xfs_icache.h"
> >  #include <linux/fsverity.h>
> >  #include <linux/iomap.h>
> > +#include <linux/pagemap.h>
> >  
> >  struct kmem_cache *xfs_fsverity_ioend_cache;
> >  
> > @@ -31,3 +40,355 @@ xfs_fsverity_is_file_data(
> >  	return fsverity_active(VFS_IC(ip)) &&
> >  			offset < xfs_fsverity_metadata_offset(ip);
> >  }
> > +
> > +/*
> > + * Retrieve the verity descriptor.
> > + */
> > +static int
> > +xfs_fsverity_get_descriptor(
> > +	struct inode		*inode,
> > +	void			*buf,
> > +	size_t			buf_size)
> > +{
> > +	struct xfs_inode	*ip = XFS_I(inode);
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	__be32			d_desc_size;
> > +	u32			desc_size;
> > +	u64			desc_size_pos;
> > +	int			error;
> > +	u64			desc_pos;
> > +	struct xfs_bmbt_irec	rec;
> > +	int			is_empty;
> > +	uint32_t		blocksize = i_blocksize(VFS_I(ip));
> > +	xfs_fileoff_t		last_block_offset;
> > +
> > +	ASSERT(inode->i_flags & S_VERITY);
> > +	xfs_ilock(ip, XFS_ILOCK_SHARED);
> > +	error = xfs_bmap_last_extent(NULL, ip, XFS_DATA_FORK, &rec, &is_empty);
> > +	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> > +	if (error)
> > +		return error;
> > +
> > +	if (is_empty)
> > +		return -ENODATA;
> > +
> > +	last_block_offset =
> > +		XFS_FSB_TO_B(mp, rec.br_startoff + rec.br_blockcount);
> > +	if (last_block_offset <= xfs_fsverity_metadata_offset(ip))
> > +		return -ENODATA;
> > +
> > +	desc_size_pos = last_block_offset - sizeof(__be32);
> > +	error = fsverity_pagecache_read(inode, (char *)&d_desc_size,
> > +			sizeof(d_desc_size), desc_size_pos);
> > +	if (error)
> > +		return error;
> > +
> > +	desc_size = be32_to_cpu(d_desc_size);
> > +	if (XFS_IS_CORRUPT(mp, desc_size > FS_VERITY_MAX_DESCRIPTOR_SIZE))
> > +		return -ERANGE;
> > +	if (XFS_IS_CORRUPT(mp, desc_size > desc_size_pos))
> > +		return -ERANGE;
> > +
> > +	if (!buf_size)
> > +		return desc_size;
> > +
> > +	if (XFS_IS_CORRUPT(mp, desc_size > buf_size))
> > +		return -ERANGE;
> > +
> > +	desc_pos = round_down(desc_size_pos - desc_size, blocksize);
> > +	if (desc_pos < xfs_fsverity_metadata_offset(ip))
> > +		return -ERANGE;
> > +
> > +	error = fsverity_pagecache_read(inode, buf, desc_size, desc_pos);
> > +	if (error)
> > +		return error;
> > +
> > +	return desc_size;
> > +}
> > +
> > +static int
> > +xfs_fsverity_write_descriptor(
> > +	struct file		*file,
> > +	const void		*desc,
> > +	u32			desc_size,
> > +	u64			merkle_tree_size)
> > +{
> > +	int			error;
> > +	struct inode		*inode = file_inode(file);
> > +	struct xfs_inode	*ip = XFS_I(inode);
> > +	unsigned int		blksize = ip->i_mount->m_sb.sb_blocksize;
> > +	u64			tree_last_block =
> > +			xfs_fsverity_metadata_offset(ip) + merkle_tree_size;
> > +	u64			desc_pos =
> > +			round_up(tree_last_block, XFS_FSVERITY_START_ALIGN);
> > +	u64			desc_end = desc_pos + desc_size;
> > +	__be32			desc_size_disk = cpu_to_be32(desc_size);
> > +	u64			desc_size_pos =
> > +			round_up(desc_end + sizeof(desc_size_disk), blksize) -
> > +			sizeof(desc_size_disk);
> > +
> > +	error = iomap_fsverity_write(file, desc_size_pos, sizeof(__be32),
> > +			(const void *)&desc_size_disk,
> > +			&xfs_buffered_write_iomap_ops,
> > +			&xfs_iomap_write_ops);
> > +	if (error)
> > +		return error;
> > +
> > +	return iomap_fsverity_write(file, desc_pos, desc_size, desc,
> > +			&xfs_buffered_write_iomap_ops,
> > +			&xfs_iomap_write_ops);
> > +}
> > +
> > +/*
> > + * Try to remove all the fsverity metadata after a failed enablement.
> > + */
> > +static int
> > +xfs_fsverity_delete_metadata(
> > +	struct xfs_inode	*ip)
> > +{
> > +	struct xfs_trans	*tp;
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	int			error;
> > +
> > +	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
> > +	if (error) {
> > +		xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> > +		return error;
> > +	}
> > +
> > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, ip, 0);
> > +
> > +	truncate_inode_pages(VFS_I(ip)->i_mapping, XFS_ISIZE(ip));
> > +
> > +	/*
> > +	 * We remove post EOF data, no need to update i_size as fsverity
> > +	 * didn't move i_size in the first place
> > +	 */
> > +	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, XFS_ISIZE(ip));
> > +	if (error)
> > +		goto err_cancel;
> > +
> > +	error = xfs_trans_commit(tp);
> > +	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_ILOCK_EXCL);
> > +	return error;
> > +err_cancel:
> > +	xfs_trans_cancel(tp);
> > +	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_ILOCK_EXCL);
> > +	return error;
> > +}
> > +
> > +
> > +/*
> > + * Prepare to enable fsverity by clearing old metadata.
> > + */
> > +static int
> > +xfs_fsverity_begin_enable(
> > +	struct file		*filp)
> > +{
> > +	struct inode		*inode = file_inode(filp);
> > +	struct xfs_inode	*ip = XFS_I(inode);
> > +	int			error;
> > +
> > +	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
> > +
> > +	if (IS_DAX(inode) || ip->i_diflags2 & XFS_DIFLAG2_DAX)
> > +		return -EINVAL;
> > +
> > +	if (inode->i_size > XFS_FSVERITY_LARGEST_FILE)
> > +		return -EFBIG;
> > +
> > +	/*
> > +	 * Flush pagecache before building Merkle tree. Inode is locked and no
> > +	 * further writes will happen to the file except fsverity metadata
> > +	 */
> > +	error = filemap_write_and_wait(inode->i_mapping);
> > +	if (error)
> > +		return error;
> > +
> > +	if (xfs_iflags_test_and_set(ip, XFS_VERITY_CONSTRUCTION))
> > +		return -EBUSY;
> > +
> > +	error = xfs_qm_dqattach(ip);
> > +	if (error)
> > +		goto out_clear;
> > +
> > +	error = xfs_fsverity_delete_metadata(ip);
> > +	if (error)
> > +		goto out_clear;
> > +	return error;
> > +out_clear:
> > +	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
> > +	return error;
> > +}
> > +
> > +/*
> > + * Complete (or fail) the process of enabling fsverity.
> > + */
> > +static int
> > +xfs_fsverity_end_enable(
> > +	struct file		*file,
> > +	const void		*desc,
> > +	size_t			desc_size,
> > +	u64			merkle_tree_size)
> > +{
> > +	struct inode		*inode = file_inode(file);
> > +	struct xfs_inode	*ip = XFS_I(inode);
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_trans	*tp;
> > +	int			error = 0;
> > +	loff_t			range_start = xfs_fsverity_metadata_offset(ip);
> > +
> > +	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
> > +
> > +	/* fs-verity failed, just cleanup */
> > +	if (desc == NULL) {
> > +		error = xfs_fsverity_delete_metadata(ip);
> > +		goto out;
> > +	}
> > +
> > +	error = xfs_fsverity_write_descriptor(file, desc, desc_size,
> > +			merkle_tree_size);
> > +	if (error)
> > +		goto out;
> > +
> > +	/*
> > +	 * Wait for Merkle tree get written to disk before setting on-disk inode
> > +	 * flag and clearing XFS_VERITY_CONSTRUCTION
> > +	 */
> > +	error = filemap_write_and_wait_range(inode->i_mapping, range_start,
> > +			LLONG_MAX);
> > +	if (error)
> > +		goto out;
> > +
> > +	/*
> > +	 * Set fsverity inode flag
> > +	 */
> > +	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_ichange,
> > +			0, 0, false, &tp);
> > +	if (error)
> > +		goto out;
> > +
> > +	/*
> > +	 * Ensure that we've persisted the verity information before we enable
> > +	 * it on the inode and tell the caller we have sealed the inode.
> > +	 */
> > +	ip->i_diflags2 |= XFS_DIFLAG2_VERITY;
> > +
> > +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> > +	xfs_trans_set_sync(tp);
> > +
> > +	error = xfs_trans_commit(tp);
> > +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > +	if (error)
> > +		goto out;
> > +
> > +	inode_set_flags(inode, S_VERITY, S_VERITY);
> > +
> > +	/*
> > +	 * Proactively remove unwritten extents left by COW preallocations and
> > +	 * write preallocation in the merkle tree holes and past descriptor,
> > +	 * and any delayed preallocations
> > +	 */
> > +	error = xfs_free_eofblocks(ip);
> > +out:
> > +	if (error) {
> > +		int	error2;
> > +
> > +		error2 = xfs_fsverity_delete_metadata(ip);
> > +		if (error2)
> > +			xfs_alert(ip->i_mount,
> > +"ino 0x%llx failed to clean up new fsverity metadata, err %d",
> > +					I_INO(ip), error2);
> 
> We just set S_VERITY on the VFS inoe, but then xfs_free_eofblocks fails.
> Should we clear S_VERITY?
> 
> Does xfs_fsverity_delete_metadata need to clear XFS_DIFLAG2_VERITY?

Yes, that's right. I will look if it's fine to move all the clean up
logic to xfs_fsverity_delete_metadata().

> 
> > +	}
> > +
> > +	xfs_iflags_clear(ip, XFS_VERITY_CONSTRUCTION);
> > +	return error;
> > +}
> > +
> > +/*
> > + * Retrieve a merkle tree block.
> > + */
> > +static struct page *
> > +xfs_fsverity_read_merkle(
> > +	struct inode		*inode,
> > +	pgoff_t			index)
> > +{
> > +	index += xfs_fsverity_metadata_offset(XFS_I(inode)) >> PAGE_SHIFT;
> > +
> > +	return generic_read_merkle_tree_page(inode, index);
> > +}
> > +
> > +/*
> > + * Retrieve a merkle tree block.
> > + */
> > +static void
> > +xfs_fsverity_readahead_merkle_tree(
> > +	struct inode		*inode,
> > +	pgoff_t			index,
> > +	unsigned long		nr_pages)
> > +{
> > +	index += xfs_fsverity_metadata_offset(XFS_I(inode)) >> PAGE_SHIFT;
> > +
> > +	generic_readahead_merkle_tree(inode, index, nr_pages);
> > +}
> > +
> > +/*
> > + * Write a merkle tree block.
> > + */
> > +static int
> > +xfs_fsverity_write_merkle(
> > +	struct file		*file,
> > +	const void		*buf,
> > +	u64			pos,
> > +	unsigned int		size,
> > +	const u8		*zero_digest,
> > +	unsigned int		digest_size)
> > +{
> > +	struct inode		*inode = file_inode(file);
> > +	struct xfs_inode	*ip = XFS_I(inode);
> > +	loff_t			position = pos +
> > +		xfs_fsverity_metadata_offset(ip);
> > +
> > +	if (position + size > inode->i_sb->s_maxbytes)
> > +		return -EFBIG;
> > +
> > +	/*
> > +	 * If this is a block full of hashes of zeroed blocks, don't bother
> > +	 * storing the block. We can synthesize them later.
> > +	 *
> > +	 * However, do this only in case Merkle tree block == fs block size.
> > +	 * Iomap synthesizes these blocks based on holes in the merkle tree. We
> > +	 * won't be able to tell if something need to be synthesizes for the
> > +	 * range in the fs block. For example, for 4k filesystem block
> > +	 *
> > +	 *	[ 1k | zero hashes | zero hashes | 1k ]
> > +	 *
> > +	 * Iomap won't know about these empty blocks.
> > +	 */
> > +	if (size == ip->i_mount->m_sb.sb_blocksize &&
> > +			/*
> > +			 * First digest is zero_digest
> > +			 */
> > +			memcmp(buf, zero_digest, digest_size) == 0 &&
> > +			/*
> > +			 * Every digest is same as previous, thus all are
> > +			 * zero_digest
> > +			 */
> > +			memcmp(buf + digest_size, buf, size - digest_size) == 0)
> 
> Weird indentation in this very long if test.  Please just put that in a
> separate helper:
> 
> static inline bool
> xfs_fsverity_is_hashes_of_zeroed_blocks(...)
> {
> 	/*
> 	 * If this is a block full of hashes of zeroed blocks, don't bother
> 	 * storing the block. We can synthesize them later.
> 	 *
> 	 * However, do this only in case Merkle tree block == fs block size.
> 	 * Iomap synthesizes these blocks based on holes in the merkle tree. We
> 	 * won't be able to tell if something need to be synthesizes for the
> 	 * range in the fs block. For example, for 4k filesystem block
> 	 *
> 	 *	[ 1k | zero hashes | zero hashes | 1k ]
> 	 *
> 	 * Iomap won't know about these empty blocks.
> 	 */
> 	if (size != ip->i_mount->m_sb.sb_blocksize)
> 		return false;
> 	/*
> 	 * First digest is zero_digest
> 	 */
> 	if (memcmp(buf, zero_digest, digest_size))
> 		return false;
> 	/*
> 	 * Every digest is same as previous, thus all are
> 	 * zero_digest
> 	 */
> 	return memcmp(buf + digest_size, buf, size - digest_size) == 0;
> }

sure

> 
> (Don't you need to compare all the hash slots in the buffer??)

Oh that's neat optimization suggested by Eric, you can check that
first hash is correct (first memcmp) and then compare second to the
first, third to the second etc. to check that they're all the same
(second memcmp).

-- 
- Andrey

