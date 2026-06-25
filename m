Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A2B2BE7DB;
	Thu, 25 Jun 2026 11:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782387332; cv=none; b=V7RM3pgsTKl+mC5DWO6ESFWY54gBg0Z5PykNpAa0fEu3SUVEwrSa4CGRfHaFeHRQDI8kt100DhBWJfSTr2t89HNcZWWM0pUDiLQpBeA6AagyLcsx6F1Am5LMU7lkxasK6rKRRWHcHCt+qPpvLzSYNnsOK5JqgDo+T06Y5SxqSdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782387332; c=relaxed/simple;
	bh=gk9Wpf5x30UBAgIye/6MhuKBmdy5XK+9aJd5ScWBNzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=puEHz3qfKkQX/hdoVYyeQFxO1Ezc/06KkrxMDj5uKeHUrClLptI8K/t7EtZNNbTslidpehFehq1IDS0q7mMgh4MDeK6zI9Ac8LBZiOKKCjYxO2ZMcoRJ0I5iEt6tjfwstD9h+VLMxPq1PYKA2S4qKnjzv16QnH5QZ+hzVjtRZMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=teFOIKrL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="teFOIKrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFC21F000E9;
	Thu, 25 Jun 2026 11:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782387331;
	bh=9hXO385gf9P0OlTj4W9SgtyQdtKMg7hoTES325U6mGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=teFOIKrLVSCbT0w4Yxh1I1UWLD0VQuT0PsDn3zSissgfZxMDGptSHjvyWM46Tk780
	 i/ib7fEj7FsCazKYrr//GFZfUArBNgxF1tYls3O7EDApNL9h9t3sHJyS+6PEiBwZ9Z
	 zOtz7DGjumvU+b+N7sH3kF0u6T6HOJI+gh82jOwg=
Date: Thu, 25 Jun 2026 12:31:35 +0100
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
Subject: Re: [stable/linux-6.12.y 0/2] Backport Fix incorrect overlayfs
 mmap() and mprotect() LSM access controls
Message-ID: <2026062521-shingle-degrease-a584@gregkh>
References: <20260622031509.2663919-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622031509.2663919-1-caixinchen1@huawei.com>

On Mon, Jun 22, 2026 at 11:15:07AM +0800, Cai Xinchen wrote:
> Backport the patch series
> "Fix incorrect overlayfs mmap() and mprotect() LSM access controls" [1]
> to 6.12 lts
> 
> I test selinux-testsuite[2] overlay test, it pass 135 tests.
> 
> [1] https://lore.kernel.org/all/20260403030848.731867-5-paul@paul-moore.com/
> [2] https://github.com/SELinuxProject/selinux-testsuite

Again, upstream git ids are needed.  Please redo all of these and
resend.

thanks,

greg k-h
