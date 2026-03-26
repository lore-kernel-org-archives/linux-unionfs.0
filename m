Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0ED37C0E7;
	Thu, 26 Mar 2026 14:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774534466; cv=none; b=ABLYtzznskeWUG2er2FNZ9IDYzdOMZ7jrzN1uFH104zF2Yji2FngW9XnlnN6j8Bywagsj5PetCCZnQuk+QQgqUiH3Tb+J1USgvd7HLKoRGo9oA6mIME/dLh/brIw5HTDGGqiMUPCRhW5q5hEINgB5Cn6c4y+XPasfEbel3RU6mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774534466; c=relaxed/simple;
	bh=9/Mc8wqWTo8FPFWf+YyPCWyvxNDgMHkuBpBcOLX21aE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mv+mphfZOO/pf6e3TK9ER5LSRLE0FTEn3xOgNLreS8wgCUI8BiuqsmtnR2SlyBHET3ymkt6nFr9vE/xHedDlP57M6Z0xNhACSzmRzgNmm+WZ1kevDZC0YdsdUv0T79gWmE19m3L1XiVEKd0wEJJ8sRXnrRt2nz9SBe9FjMogVWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cU6Z0CDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cU6Z0CDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F086EC116C6;
	Thu, 26 Mar 2026 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774534466;
	bh=9/Mc8wqWTo8FPFWf+YyPCWyvxNDgMHkuBpBcOLX21aE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cU6Z0CDKLvPywdcWRaVckLWCGFMQ9BFlM0IEu+M554IZykD8OMttZxM4vFECn2de6
	 ljdVm+SE1Y90FqE/VgCURofZNyRt9oI6AQy/20XN3PiiBzTgrHnRt3bU3BSdQXS8QZ
	 oPKMegFXcX7QdSNJdkkklUOF6HVdAyxoVsaK6kt94bavqoexspxGFRrGuaKDXleUNA
	 7GCmlhztB8Wkb+qSttaCbKQX+vWak9Qin5x5NJ+HINkXo/DHgCSKMV2r301dRSdvx/
	 NU3VvJfrdunBQ9tV5NvKzAAALXy5VdZLNcaSLBJloG3/atVngBKzhRho/7YnFWZqJv
	 5qFkISDTdKr+A==
Date: Thu, 26 Mar 2026 15:14:21 +0100
From: Christian Brauner <brauner@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	Amir Goldstein <amir73il@gmail.com>, Gao Xiang <xiang@kernel.org>
Subject: Re: [RFC PATCH v2 1/2] lsm: add backing_file LSM hooks
Message-ID: <20260326-wildwasser-notorisch-7271180258ef@brauner>
References: <20260323042510.3331778-4-paul@paul-moore.com>
 <20260323042510.3331778-5-paul@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260323042510.3331778-5-paul@paul-moore.com>

On Mon, Mar 23, 2026 at 12:24:18AM -0400, Paul Moore wrote:
> Stacked filesystems such as overlayfs do not currently provide the
> necessary mechanisms for LSMs to properly enforce access controls on the
> mmap() and mprotect() operations.  In order to resolve this gap, a LSM
> security blob is being added to the backing_file struct and the following
> new LSM hooks are being created:
> 
>  security_backing_file_alloc()
>  security_backing_file_free()
>  security_mmap_backing_file()
> 
> The first two hooks are to manage the lifecycle of the LSM security blob
> in the backing_file struct, while the third provides a new mmap() access
> control point for the underlying backing file.  It is also expected that
> LSMs will likely want to update their security_file_mprotect() callback
> to address issues with their mprotect() controls, but that does not
> require a change to the security_file_mprotect() LSM hook.
> 
> There are a two other small changes to support these new LSM hooks.  We
> pass the user file associated with a backing file down to
> alloc_empty_backing_file() so it can be included in the
> security_backing_file_alloc() hook, and we constify the file struct field
> in the LSM common_audit_data struct to better support LSMs that need to
> pass a const file struct pointer into the common LSM audit code.
> 
> Thanks to Arnd Bergmann for identifying the missing EXPORT_SYMBOL_GPL()
> and supplying a fixup.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
>  fs/backing-file.c             |  18 ++++--
>  fs/erofs/ishare.c             |  10 +++-
>  fs/file_table.c               |  21 ++++++-
>  fs/fuse/passthrough.c         |   2 +-
>  fs/internal.h                 |   3 +-
>  fs/overlayfs/dir.c            |   2 +-
>  fs/overlayfs/file.c           |   2 +-
>  include/linux/backing-file.h  |   4 +-
>  include/linux/fs.h            |   1 +

Thanks, this looks much better.
Acked-by: Christian Brauner <brauner@kernel.org>
