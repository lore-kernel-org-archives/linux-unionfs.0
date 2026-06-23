Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6429737CD33;
	Tue, 23 Jun 2026 13:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222173; cv=none; b=LKS4e1roM/1kO7CKx2+LmeTnjJRNVRiMeyXr1Oo/p98CKq3sh7PTCYYbknBkR2qJVZXvzybJ1Wc9KA5qJimVWJQKe+TeN0dQSYtUQBLkf6Lv3fJ0mU1z2LbthpfGhZ/b5Evm2WzP75/KQFJ9AS/6kJ25sS+oNiYjUTj2VE+lyFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222173; c=relaxed/simple;
	bh=da4yloba4EKZxA1J5o/QFN9LRCJPhXwekI9cm6VOf4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TnAj4tWIWvD4EM58PIp4ZKhm2NL9HMS/ZzT3O+YeyCAJsRrIBCqe0tF9g9qXFmJ0Y9QCLRpaZbVIkvY+m79Q1daX+TsTbzC8OHC9lbvAano/j97DRikqjch63nfIbPQGKl0wH3P/KnSOPA+ZQ0Jv0QzWSGFaJcXceVfdCqJfEH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1616F68C4E; Tue, 23 Jun 2026 15:42:41 +0200 (CEST)
Date: Tue, 23 Jun 2026 15:42:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, miklos@szeredi.hu,
	amir73il@gmail.com, linux-unionfs@vger.kernel.org,
	fuweid89@gmail.com, Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
Message-ID: <20260623134240.GA7980@lst.de>
References: <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com> <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com> <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com> <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com> <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com> <13bb8cba-c82e-4a41-aff1-0a6418873bf1@linux.alibaba.com> <CALOAHbCkbSBVqUStUbWB=4vUUOEyB63yMsXvS_cZUZOwr-nmew@mail.gmail.com> <a5a1b56f-0b1a-473d-8fc9-8cbfba85813e@linux.alibaba.com> <CALOAHbCrvbvT04O3v+p-CmdqVN2BGJYKj6F7we70kPwbs-hmRw@mail.gmail.com> <b4d43064-7a7d-4d65-b65c-56e80d47ed17@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4d43064-7a7d-4d65-b65c-56e80d47ed17@linux.alibaba.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

I have no idea where this coming from as I can't find an earlier
version in the fsdevel archives.  But changing user visible mount
options through konfig options is simply bonkers.

I'd also like to not that the submitter does have a history of crazy
patches including those to support proprietary modules and then
attacking people criticizing those patches, so I can only suggest to
every maintainer to ignore them for their own sanity.

