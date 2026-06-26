Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A219F27FD51;
	Fri, 26 Jun 2026 07:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782457721; cv=none; b=Squ22s/xWfR7nGq/8xhcTFLSyfEKUQY0XjTMKflioF+JLycrEYmSmY+n/6mpn7zd0iO8hmDoUq+C1p25LhrVEPjVTS9qDyNfJ5Yd/Y5npPDrkuILm8LaSA2pPdTl0YUvWd1aPbSaq9i+mRPtmEkxh93ZYV759Bv8YT5GSYRnYKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782457721; c=relaxed/simple;
	bh=jEdDswGvs0SXZNje9yffbrjrkR2Zw9Wo/fCNd/kmlUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l/jxzz24Gc+WG3cbYYISjcjmZvemiUZ7dFRXVQWUugrJCxojiOtGhLYqKISBGy8ZeYXzmasgRkKDhY31/WVgNX+6YqN36i5tTpOrmPSukD1BoyTss1//K6tVMDJtf7Pbz6soMl6XnN4uf4rkOgUO3mwe5yJY5LglzBqyvdS/aME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovbIpnoq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovbIpnoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04F51F000E9;
	Fri, 26 Jun 2026 07:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782457717;
	bh=jEdDswGvs0SXZNje9yffbrjrkR2Zw9Wo/fCNd/kmlUQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ovbIpnoq18k2w1g50a5UKNCa4Ag/wsDqLWG8hpzJdx7XIdZ0sPFhGMxpFqT1lYDEL
	 lvzT9QAF9f9msACFhjkFEmUQh+LFjuz81bASw5H/EHo0hu+pxPNhQSsIedQvAqHnwT
	 ECaSQcpMDw6pJtb9q1+qkZ71R4cMS5DxG2VtfH7M=
Date: Fri, 26 Jun 2026 08:07:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	miklos@szeredi.hu, amir73il@gmail.com, paul@paul-moore.com,
	jmorris@namei.org, serge@hallyn.com, stephen.smalley.work@gmail.com,
	omosnace@redhat.com, bboscaccy@linux.microsoft.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	bpf@vger.kernel.org, lujialin4@huawei.com
Subject: Re: [PATCH v2 stable/linux-6.18.y 0/2] Backport Fix incorrect
 overlayfs mmap() and mprotect() LSM access controls
Message-ID: <2026062605-broadways-stuffy-2ec4@gregkh>
References: <20260626024058.3149217-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626024058.3149217-1-caixinchen1@huawei.com>

On Fri, Jun 26, 2026 at 10:40:56AM +0800, Cai Xinchen wrote:
> v2: Add static to struct kmem_cache *lsm_backing_file_cache; and define
> lbs_backing_file as int for keeping the same type as 6.18.

Why are you not actually cc: stable@vger.kernel.org on backports you
want to see applied there?

confused,

greg k-h
