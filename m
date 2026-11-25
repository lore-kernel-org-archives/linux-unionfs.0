Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795584551;
	b=d/MQyGJECANPX/lVN+BH1ypEO+jJlXdFi/B2Iqt2cu+HTlHPI8k9KNuDrAZFnNmPV+lU
	 6FjFQsQEMA/2yO692sqYkcnEOJbr8Wxg89eBl7Ox2hSKRoaCmDRdulcWrppxrr7U3km5V
	 16HFQb143DOGd7YHdUJIhwjRk1gRNnPQnufDArAjMnLMkF0T/uFEh6EZjUKbKB24h6b+4
	 P0/+y613VD7a6nVFq99iYd0exS49tOA/yEkDqFD83oc2B8qJkyIDEm8ifMgGaLInb4l33
	 cvAulveUKP8q/j0Gqa4SwDwUr/QOiz1hcorCx020zSV7TgALzsEpAEm8fV0iLnJshlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795584551;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=D5V76xvx94Dj5TuaV3PyCuVUDRRh/mRfwAoNPEd3B5s=;
	b=GMGNmmMR6pHz1dxwSZT0AGv3E0FR7AI+EG+5srxbxHb0PNKaUYtqPBDgi5n/r7PW0j6E
	 BsTrD1IQ8iEz6LMVjpd3DYkxvV/Ulb94DoW/Afyox3Hr9q4P/LTHzC88CCJGgRjjwIPTQ
	 WNVsxzkgu1GXlfB4ReUGRddC5fLmWNi8TPrEyt0LVvDggA+8+kYlgbhF+EeCeWruguNzx
	 390uRmVUglTvf+yNmZc8pdEB72WymxbKvaYdddsRdp7j8lfFqv1agkPnNB5YCOvfGyhjd
	 XO07zXUeSAZvJ0nZhHLvlCba1OWR0D/iZt6C/myQTlVmbiWtV8Jr0MrvqLMqVR2v/6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4300C606A31E;
	Wed, 25 Nov 2026 05:29:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4300C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D9D4568AFE; Wed, 25 Nov 2026 06:29:06 +0100 (CET)
Date: Wed, 25 Nov 2026 06:29:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>, Chris Mason <mason@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] xattr: enforce the name and size limits for
 in-kernel callers
Message-ID: <20261125052906.GA20286@lst.de>
References: <20261123113513.1910906-1-amir73il@gmail.com> <20261123165807.1939942-1-amir73il@gmail.com> <awWBG4zMDTAk2Q4n@cronus.toxiclabs.cc>
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
In-Reply-To: <awWBG4zMDTAk2Q4n@cronus.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 24, 2026 at 01:29:41PM +0100, Carlos Maiolino wrote:
> I'd use a more specific naming like xattr_check_name_len() to avoid
> confusion, but not that I'm passionate about it :)

Sounds reasonable.

> If we are trying to prevent invalid names from in-kernel callers,
> shouldn't this also protect against a zero len?

And this sounds valid too.

Otherwise the patch looks good to me.

