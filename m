Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360D73CEB8B;
	Thu, 25 Jun 2026 11:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782385660; cv=none; b=afx1VZqyLyUvHP2ejaTEwu7YpHJgkik/IjQuQ4qXxh6XeUfZeaWnc8LHujU1eyG6pXVeMrqDAMqrZUIMM2LSdzOMA6VpOrhquOirgmroXzJ7wh5ThMZWDBQ8aN5bpEw5xDjVoH0ivGn9QswVirGl01pgi6AXWmDpnFyosUxb3cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782385660; c=relaxed/simple;
	bh=pmEikduTI5YgI55529k9p8shq835BrV1IUg5JvXPwkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5RCE4pYxgvBJAtcvdS6ZgwN8tWrW1GWTEvxCcYbAYvTA2n644HdZCVaIzKqk0JqTYFpnP6bcPk4HuLxpS8MdfCZ5gae4F2frAkgQVCXYDDRpKZ97craiDowom5oNgVDfHOWJ7F/QHz9MuiqRT9a5y9DCheTL2b3SXMI/zplzS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ei141MQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ei141MQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94781F000E9;
	Thu, 25 Jun 2026 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782385658;
	bh=Mzhl2LbNzSyg+FRv3npvLZEgHfcnVUjIab/9uAnyGXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ei141MQrqQcDOBYWVG6KZtkcRvJ7lJrim31gd2xnxJs3yJnhKuHsRBs8KqjXIpTBP
	 VKSYBpi3Yvapdo8V23Lhd//sIe2OqoLiL9b7/fMC3dJoQdOW5ZcHEU1lvPlA3sdVrI
	 TfYGQ8ypRvxZmEsGKfUku2C9erfFIl8Tk5gqHMSk=
Date: Thu, 25 Jun 2026 12:06:26 +0100
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
Subject: Re: [stable/linux-6.18.y 1/2] lsm: add backing_file LSM hooks
Message-ID: <2026062557-dancing-deeply-6edd@gregkh>
References: <20260622031416.2663747-1-caixinchen1@huawei.com>
 <20260622031416.2663747-2-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622031416.2663747-2-caixinchen1@huawei.com>

On Mon, Jun 22, 2026 at 11:14:15AM +0800, Cai Xinchen wrote:
> From: Paul Moore <paul@paul-moore.com>
> 
> Mainline declares lsm_backing_file_cache in security/lsm.h.  Linux 6.18.y
> does not have security/lsm_init.c or security/lsm.h; the cache variable
> is defined locally as static struct kmem_cache *lsm_backing_file_cache in
> security/security.c.
> 
> Original commit message:

What is the original git commit id?

ANd put the "changes" down in the signed-off-by area, like other
backports normally do please.

thanks,

greg k-h
