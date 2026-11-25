Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586820;
	b=1okdzeOl2saooMuZY6kCHkLihQc3fOajtEc6AQgLdGDJAVouhKMj7kNPfEfZKVJMUH2W
	 sXOXwGYqUq/hWu7UaukjBrgnd+WWNthrthc+n8cEFIMklkeYuW2cnacJjBew9Pcw/f3H3
	 9Xowd/KEqw061OE1IUqbZJCQLwNVgJ2sZY4Doswogjib+8kvG5Gy8e8xOxxHLEuDxphvl
	 zsAdXoSSwHhwSGiSDZViLaepXLujsGRU5sAPFmqpy3LK/fWPyCQGNoQ0MY7To/dSVvrKA
	 Pu2FPOre96AOjlJhmtM6ZrYjDlsydC/fpRzjeLymN34MrBCSLwafJj2/QDPQRGpO2Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586820;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=d+WnrQuDHOeju0fnIMKhXc00sufpW6/hDME/oLBZ9IKhAPqCzdAEqi6P30KAnfF6gHqe
	 A4VwAhFZQVp+u5koFucIPRHC7rvX0V6AGvC8r3K9Its0hISFYYACJqEXoa/LcI2ozhZUJ
	 tTaQhiHSXAMqsSsS9gaqXjYhoPCnqT8gwByfyz83iSEmJwREE/vFHlZ3avGNCWv+4ouvH
	 49KXdyGrpBF/rey1klWNSyMS02VY0Yz1A2YRXOO/sxeb4M3YJq5SWkmY9FS96vCuqUnLJ
	 JsdFfCgvb1B63h4mAH+lUBqHJAOJQvXmVZd5aIiElPU7ARDmAFBxpgl3TB8+yZFvpYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C76D606A31E;
	Wed, 25 Nov 2026 06:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C76D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BEC6D68BEB; Wed, 25 Nov 2026 07:06:53 +0100 (CET)
Date: Wed, 25 Nov 2026 07:06:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>, Chris Mason <mason@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
	Carlos Maiolino <cem@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org, stable@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: Re: [PATCH v3] xattr: enforce the name and size limits for
 in-kernel callers
Message-ID: <20261125060653.GA20848@lst.de>
References: <20261123165807.1939942-1-amir73il@gmail.com> <20261125055900.2077059-1-amir73il@gmail.com>
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
In-Reply-To: <20261125055900.2077059-1-amir73il@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

