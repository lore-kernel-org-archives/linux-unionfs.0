Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793386147;
	b=ajzm7Z15qcYIJV3Y1aUb7z04DACBTcaBcehxDN3coAEObrh1L0j/d86nnbT5Ul9cdO3O
	 1JlBJVdz2DiGHSbgpVNslsEuYbBHiRZ0E4RrAMO0z3jCX4OU9xqgMaXLpAV4CV8neKyra
	 BGgEo7DhSZcYYQA06/PkKX/7VBGoA3HOUqGWGOe0ejhMuEaMQlyrOmGkj8GA8klLL9qj9
	 +HygqPuirY7iF0kHfdNk6v47t+BhDTaBx/p81UnLVvJ6RYyLde9PJcoKDqbtDcYVQIGXQ
	 pZqU4++XUxjwZ+q2bwBIt07MNf2Ysyl+lJiHivpWIGDKhMrTOT/TLbrVfQ9vqvYG1Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793386147;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=jaAwLDiZi+eXYpWA8yr8jKN0Kz4vKoh1/crnmVZA9I0=;
	b=V2D4PWyMb1cCG6Sp/RUzB4n2UoI/oJFOYb3SF1rwpME7sKN6g41EZ2UFsGkNoJZlu9bo
	 9K0z/Po2ltWkQmMkL8E0Ohl6aWvFLitKoOT9PZMDa06yLZt13yqrRbzw5biwX6BdcFp8R
	 x9q/XOjpWAevbG+0nFRp4AffGqVxrnLfStR5K6E36f/GKVphc8/JFTgnVkBxBIQ1Mb0d/
	 mqEp6+yrrjdS3eNfGPntFeRXrRQLPORpem14i+euOeX+QVNGRBWm6PbC63F7dQYT9c0mJ
	 2GhZ/bV+P7MNnsnGLuWoAtYaS5SX33mSKZzrHFwNvZK6CWlyFEZFpCcwdt3uswFY+SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=JomhdLvU;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B782606A31D;
	Fri, 30 Oct 2026 18:49:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B782606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=JomhdLvU
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:From:Cc:To:Subject:
	MIME-Version:Date:Message-ID:From:Reply-To;
	bh=jaAwLDiZi+eXYpWA8yr8jKN0Kz4vKoh1/crnmVZA9I0=; b=JomhdLvUYFTv8zx2svwbqEhnYO
	9Au6yJyTKPEAnB3+aiHS/XLk12Ly6XaBpLAbel9gyk+vkbrf2ogcqMK7WFzho/7jZtxiLPXumzfBt
	DeFL1GSX8/xPRV7wLm/MsA6yAEwBqExgCnUAOHP0EilsVxGKVTnZnvWCQfrUvMq+BwVqm0jh5Jm4I
	bbtLyMX3d1yg4qJGcDqASlEbMBGwyGOXkolMgZkp5DhSUX/efk2DzBEMv9hYInYPcpyseLPIGvns4
	yom2h57OP/TbtfDhNDasJP4WpZ/jYW1ASA5xBZjy5IOJ1nIWuNNH5jb0DB3YVucgosylx2XPsStrw
	ryU/tn/A==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1xMrew-00FGSZ-V6; Fri, 30 Oct 2026 19:49:03 +0100
Message-ID: <590a361e-d54c-45ca-a65d-6ecac8bc9669@igalia.com>
Date: Fri, 30 Oct 2026 15:49:09 -0300
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: restrict casefold consistency checks to directories
To: Hungyu Lin <dennylin0707@gmail.com>, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, miklos@szeredi.hu
References: <20261028154008.67451-1-dennylin0707@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <20261028154008.67451-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Em 28/10/2026 12:40, Hungyu Lin escreveu:
> ovl_lookup_single() compares every positive child's casefold flag with
> that of the overlay. On casefolded ext4, regular files do not inherit
> the casefold flag from their parent directory. Looking up an existing
> regular file on a casefolded overlay therefore fails with EREMOTE.
> Symlinks, FIFOs and whiteouts are rejected by the same check.
> 
> Restrict the child consistency check to directories, along with the
> corresponding assertion in ovl_get_inode(). This allows nondirectory
> objects to be looked up without rejecting them or warning about their
> flags, while directories with inconsistent casefold settings are still
> rejected.
> 
> Fixes: 16754d61dc69 ("ovl: Support mounting case-insensitive enabled layers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Reviewed-by: André Almeida <andrealmeid@igalia.com>
