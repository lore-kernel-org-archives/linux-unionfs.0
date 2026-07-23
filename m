Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E1340F756;
	Thu, 23 Jul 2026 23:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784849361; cv=none; b=UKgsSJ9P42bmyR/16D48LQAx0/SP/+zHxcxcQUUoPaNG5NJa8hSTyG1bq5uSnStWHBP+jXenc0lYDWNzezKq4Sh9uNBqb99Kqlr4St5QMpj4hr5r0XTeghEI6v519XEhCveoje45cFL1QpIQiQ9ab1kaj+pzSW0esr8g6fcV8OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784849361; c=relaxed/simple;
	bh=sJSOrYYVOOyBJm/dSOFF9WtHLOc2KE9elMrxw6Auo8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pudbJk/RSt6p4U3Lguu+ryrpyfCnxaMu6EjZxuERA5nfnKhwNu0Cizt8G8V2D6nyirfuCtDPuL8awoaYK2GCPykKyLw1DsB+f1eB/yabDQ3M22TE5foT8mVvueV0f4c9KMkkIEZCIKVPatPHJQRwuXUTlN+eLR4z3B/radL8t0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKyrF1ZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKyrF1ZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468D61F000E9;
	Thu, 23 Jul 2026 23:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784849359;
	bh=p+a/BKnF//emlOrUpqbilq4s46Jo1q4k5JP7tcoZWvU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CKyrF1ZPzD4J+biPWTG9W7JL0LI1nSBzMFry8qGB+j8IVNGxaf7/+Pwht9Ectn/EU
	 t2SVDlljyQxmsZse299GmQ+NfQCTDNb0aEfjgP6lphFeJo/+Z2B8f5szbjBDHHCJ/W
	 QJgmoNJnIA462rXCF1y2wmQdzJDYLQVjdUMmYS72h9lkVOqDErANJl/zjdT5cK12Zp
	 uDhOLs5z4iDRmVhc8UeraAB1FYIYFRqyHUfh+6RCxDycikwmoUTq5IyhGZ78IC4v9X
	 Cq3ZM6owYKby/CFX4qiMZxNv6dJpDcDKPBDC82dvRueaXehdJjTE9Mf6oVnJYYp2mT
	 VF/RkJIQ11UuA==
Date: Fri, 24 Jul 2026 07:29:14 +0800
From: Gao Xiang <xiang@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] Proposal for Cross-fs copy_file_range()
Message-ID: <amKjyp78ngW2Kmku@debian>
Mail-Followup-To: Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Daan De Meyer <daan.j.demeyer@gmail.com>,
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20260723114848.1212429-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260723114848.1212429-1-amir73il@gmail.com>

Hi Amir,

On Thu, Jul 23, 2026 at 01:48:43PM +0200, Amir Goldstein wrote:
> Hi all,
> 
> Daan De Meyer requested a way to do copy_file_range() from overlayfs
> to/from another fs, where if that fs is the base fs of overlayfs layer
> the copy could be an efficient clone.
> 
> TBH, he also requested support also for cross-fs clone_file_range(),
> but I am not happy about providing that.
> 
> copy_file_range() already supports cross-sb efficient copy (e.g. with
> NFS/SMB server-side copy).

I once had a long-term goal of supporting copy_file_range() between
overlayfs and EROFS for file-backed mounts, as long as the EROFS inodes
are plain (i.e. uncompressed). Such cross-fs copies could be decomposed
into one or more sub-copies from the EROFS backing file to the
overlayfs upper file, so the underlying backing filesystem can perform
the actual data transfer. If the backing filesystem supports reflinks,
those operations could even be implemented as efficient reflinks.

This would greatly optimize overlayfs copy-up for file-backed EROFS
mounts.

I think this should be feasible, although I haven't had time to work
on it yet. If clean interfaces in this area make that easier, I'd be
very happy to make use of them and enable this later.

Thanks,
Gao Xiang

> 
> The current limitation of staying on the same fstype is mainly an
> internal technical limitation (choosing the right f_op), which is
> something that this RFC is trying to address.
> 
> The overlayfs implementation itself is pretty trivial.
> 
> Thanks,
> Amir.
> 
> 
> Amir Goldstein (5):
>   fs: clarify cross-sb copy_file_range() code
>   fs: add support for copy file range from another fs
>   fs: add support for copy file range to another fs
>   ovl: add support for copy file range from another fs
>   ovl: add support for copy file range to another fs
> 
>  fs/overlayfs/file.c      |  35 ++++++++++++
>  fs/overlayfs/ovl_entry.h |   7 ++-
>  fs/read_write.c          | 119 ++++++++++++++++++++++++++++-----------
>  include/linux/fs.h       |   2 +
>  4 files changed, 130 insertions(+), 33 deletions(-)
> 
> -- 
> 2.54.0
> 
