Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203171;
	b=hliwI0jY0Cej23Gsn/PkbMyP4Mczyt9ET05lmhorG61I5RP2xeowap/2ci12txruvXc/
	 xMDMGif0FyHs+xUMu0L8/uI6sqReUGDN10xdJsAYLUujNZ/jAsGEMKBW/WdhTm2MdnrSr
	 cZXZQoHGd0s7xQ0rWDhrwUKdtcTf3kpvgpWy3jpyrXHZlVhdRtmsCeEjZk83S4XbI0QP4
	 +YzCnz5Kfjp7dMR1AtHDHgLl7iBe9y92JkL8pmPFU/BRAreTURwQ80RmH6X78MLf9nSd9
	 fWxYfDaJhoZVDiuTPeIdMpaj7KTY5+CJ7TqTBANw6qu3BVR+KtA1p7eLB2PeYrvbfwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203171;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=tPemWb2rCPGtbEKexorlNRNCXDQ/EWhUdVHMfdkbSJM=;
	b=Eq7NzkjsTkTpdK85kFHd2fBx+VGnxrgWqNyv/5BjjdCF4rtdbufX3Q3Smg3zOzCGJ5UZ
	 1gK1F0RUtdpzdvFURflZSbLseOEwGbc/ps4KFLF/XC+wbochRg1Ru5UIqut+UuGlreJDn
	 +S8yD0kBJzun1anUUECjHnM3TOvbat1CtBD1haOfEpysVTe8r9g0LhwQ3rz3rIuocFb+5
	 hskhLWeXduwgcbaIZOAG9SoHH9L1bx2lKqJFfsU07TR1TBwndGA25+x0XbjZpr0hLfh9Q
	 PV8PPKEAQ0PQZPxmikPk2/y3VbyQqlGp3LhR+ydy/oEwGp45c2xu5Cjej2Hi79LSypg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C617F606A321;
	Wed, 28 Oct 2026 15:59:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C617F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8A55068AFE; Wed, 28 Oct 2026 16:59:26 +0100 (CET)
Date: Wed, 28 Oct 2026 16:59:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zorro Lang <zlang@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2] src/vfs: skip whiteout-device fixtures on overlayfs
Message-ID: <20261028155926.GA20501@lst.de>
References: <20261017092841.2364286-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017092841.2364286-1-amir73il@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Oct 17, 2026 at 11:28:40AM +0200, Amir Goldstein wrote:
> From: Christian Brauner <brauner@kernel.org>
> 
> The idmapped mount tests create a whiteout device,
> mknod(S_IFCHR, makedev(0, 0)), as a fixture: a whiteout device is the
> only character device an unprivileged caller may create, since it is
> exempt from the CAP_MKNOD check. overlayfs reserves a 0:0 character
> device as its on-disk whiteout marker, so ovl_mknod() returns -EPERM
> and the fixture cannot be created, failing generic/633, generic/696 and
> generic/697 on overlayfs.
> 
> Add a whiteout_device_supported() helper and skip the whiteout-device
> fixtures and the checks that depend on them on overlayfs. The
> makedev(5, 1) "creation must fail" probes are unaffected and keep
> running. No-op on every other filesystem.

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

