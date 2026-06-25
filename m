Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887373B19B4;
	Thu, 25 Jun 2026 11:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782385671; cv=none; b=eOOcJVQnRhIzPcFr5dV6fRctKPtD35ZVaF6s+ISfnph7BsEtFJH/BLveUonL5XN13OnVHwgxQV9pYxk5venIuZZur3gI4FyvTbtaY+uqCp8i2WMs3uv4p9qeoMTyP0BMpm9708cX1h2M0Ss0iYGJ1L1bt/aXAntC1nWMHeJa9ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782385671; c=relaxed/simple;
	bh=ZaGQHrsu5B4E8/yrF6teUXrBsceqt6AC7Fd5+8dUGwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEwEU0AdN747eOeJ1dnp06Y3uHR6L5XKXZaR8f8nJdiGVwsR+hVWI2znjPMXmmQbmK0EyA3fAPA0Zs+96tYEvLMMuz4ERe5yNMOZxRKG44lTHZudxxsJfGDHTlLn4KeixKz7CfF8tPGcyLP8E8T3G06mNWW+SKXb6fGzr0IB9UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0l8fEeLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0l8fEeLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9647D1F000E9;
	Thu, 25 Jun 2026 11:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782385670;
	bh=/nHrn+mrSRVOJ20fuBj9leaUr9UbxIZAjuQRBG7RaB4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=0l8fEeLlQZLAeyv9XDhXjG1pgfb4Ad+Tu/Do4GcRbYF7+8CvGTZWEOpOy9yF05tuw
	 srl0FXaUJMnsBIOSMOUX7uejKjbN6qQ3aQC66jZBMB8oXJrVAlZ+W8GOp4Jiz3vrS9
	 OcNYqZ3kllMoc/yO/M1Kh1acKeX5xiNWwgXdYgrQ=
Date: Thu, 25 Jun 2026 12:06:38 +0100
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
Subject: Re: [stable/linux-6.18.y 2/2] selinux: fix overlayfs mmap() and
 mprotect() access checks
Message-ID: <2026062529-squealing-suffice-ed61@gregkh>
References: <20260622031416.2663747-1-caixinchen1@huawei.com>
 <20260622031416.2663747-3-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622031416.2663747-3-caixinchen1@huawei.com>

On Mon, Jun 22, 2026 at 11:14:16AM +0800, Cai Xinchen wrote:
> From: Paul Moore <paul@paul-moore.com>
> 
> The existing SELinux security model for overlayfs is to allow access if
> the current task is able to access the top level file (the "user" file)
> and the mounter's credentials are sufficient to access the lower
> level file (the "backing" file).  Unfortunately, the current code does
> not properly enforce these access controls for both mmap() and mprotect()
> operations on overlayfs filesystems.
> 
> This patch makes use of the newly created security_mmap_backing_file()
> LSM hook to provide the missing backing file enforcement for mmap()
> operations, and leverages the backing file API and new LSM blob to
> provide the necessary information to properly enforce the mprotect()
> access controls.
> 
> Cc: stable@vger.kernel.org
> Acked-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
> ---
>  security/selinux/hooks.c          | 242 ++++++++++++++++++++++--------
>  security/selinux/include/objsec.h |  11 ++
>  2 files changed, 189 insertions(+), 64 deletions(-)

Again, what is the git id?

thanks,

greg k-h
