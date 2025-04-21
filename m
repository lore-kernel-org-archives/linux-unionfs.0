Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676F7282F0;
	Mon, 21 Apr 2025 23:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745276423; cv=none; b=cSoF44yzoLQvzgB8Fdabu3rgof8pM3MLorf6WOFcKSoI0f+RZ6Co1oNdsSnx4S8xaCMp2tweL5zLW6vHgjN36o29sGFxM5ZfJjhI4S3+aXq4ZcmeExGUvRZwdHytljbJZja9Uk+1tRt5+DX0dMOc933y8GBpGOedZeze3KhcDq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745276423; c=relaxed/simple;
	bh=lJGzQjtKLHSpEiJfZHctSwQe7gRJY6iYROfgj0lUdl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4owhZ2OZFznYbx3B/+tDHN21w6mfv3Y894r+aad0XdFMKkw3vrCY4ljpM7IprSkp/Ub+hR718zD8m0iP1jGHmb3MUv2HA5RDuLWNXZ1FPPhqs6Opl64xX0rjUylHxfs4CKb8WehDqVStrDn9UPf9BsOrGuMMrImSor7zitWY4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i1ScrKQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i1ScrKQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D57C4CEEB;
	Mon, 21 Apr 2025 23:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745276422;
	bh=lJGzQjtKLHSpEiJfZHctSwQe7gRJY6iYROfgj0lUdl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i1ScrKQ5QrWzdNJaiC2FyWRoR2rLAfA1RwdbWdmxjxVRdbYKll2OCuVxaiRZtjAsj
	 hSym0ELWKmuwhKGs6Q+0e3gVzlEOmEZKHqdV3C0kzyTAGxZ6ut07E3uchaIY1zEso9
	 AU3cAtfyZjimm4wIVbW0nD4GH6nIH8FyETrwg9BoTLiBWI3ak1Tt1q73WHf3i/7O4O
	 gXk6ygcOjEEsgB+I7RVvqoHCZI1R+uH+4ZaQqxdzeaKytO8WBY0RmC2dB7jBN9apbz
	 z8yTfuyDTOcTBQwlxxFKmTiMX4NzPaWaUOeOof26zQjgRD79JiB5IdE1mizH74C82k
	 jxsqWn+I4wbPA==
Date: Mon, 21 Apr 2025 16:00:19 -0700
From: Kees Cook <kees@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] ovl: Check for NULL OVL_E() results
Message-ID: <202504211558.182D13B3@keescook>
References: <20241117044612.work.304-kees@kernel.org>
 <CAOQ4uxg8rNPUTk8dqz2HmvT9Avy_6WMW4xOMPtG0b8tSUWAKcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxg8rNPUTk8dqz2HmvT9Avy_6WMW4xOMPtG0b8tSUWAKcQ@mail.gmail.com>

On Mon, Nov 18, 2024 at 07:20:52PM +0100, Amir Goldstein wrote:
> On Sun, Nov 17, 2024 at 5:46 AM Kees Cook <kees@kernel.org> wrote:
> >
> > GCC notices that it is possible for OVL_E() to return NULL (which
> > implies that d_inode(dentry) may be NULL).
> 
> I cannot follow this logic.
> 
> Yes, OVL_E() can be NULL, but
> it does not imply that inode is NULL, so if you think that
> code should to be fortified, what's wrong with:
> 
>  struct dentry *ovl_dentry_upper(struct dentry *dentry)
>  {
> -       return ovl_upperdentry_dereference(OVL_I(d_inode(dentry)));
> +       struct inode *inode = d_inode(dentry);
> +
> +       return inode ? ovl_upperdentry_dereference(OVL_I(inode)) : NULL;
>  }
> 
> TBH, I don't know where the line should be drawn for fortifying against
> future bugs, but if the goal of this patch is to silene a compiler warning
> then please specify this in the commit message, because I don't think
> there is any evidence of an actual bug, is there?

Sorry for the delay on this! I'm finally coming back around to these
fixes. :)

Yes, your suggestion works very nicely! That entirely solves the GCC
warning.

And correct, this was to deal with an over-eager compiler warning --
there was no bug here that I'm aware of.

I will send an updated patch with your suggestion.

-Kees

-- 
Kees Cook
