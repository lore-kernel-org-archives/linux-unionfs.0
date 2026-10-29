Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275450;
	b=Wl7Kd9xc3glynQ9Z2js1baddLPAomxfsHeYXppZFOQ6LQ0k22JUExC15wYCYS9TcOKAD
	 hWU6+wO2MLHukNawSVCbx7KlbNuzWPTq9raTziYCqklC8QH3za9MPoYP0e8+EvPZAvx8G
	 qohfM64zbCOuN6MpZ++/DOOYAzY3yKFOMbdf2hgAbe4zTEQaD4dTzTfEFdvca6sI2e8v1
	 ww/cRmJL25+uw/PSkNI/ZXTna51O5dSB+S93a8TJFyLMJdc/s6IOd/zT9xFKQbungywka
	 MFtwLLqW1pCdyA4I4NR7m2ZVKH4JVHaj9elTbW6wJsPy/p3I1TexhCS5YX31+SXWE0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275450;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xlnl9A/D3fizgFoXsRorCiZXKZmn/GF+FXZ2ULqWag8=;
	b=5uAVOP5R9f0V5Bl8NoVDdAloRiXyut2ecLIFui/Ke4B+ube6gj4DaquQfYmtqhBfMfiQ
	 VYPkWfYRcloC+8xYyP8/nO2QD0XpA42Qg1DgPHa3MJgmIywBzNe/3GggnlAHt4sIlk93/
	 Jg9YwBuY12ZiLefTLVYiogMb5tl1LWfJFpXrP4NaSkcoAajXOZ/fO3ymcIU/MK4OUWf82
	 qp8bMjdEoyltKEg9iVICb3Phhn2wLh4362sEVR91ZC28OW9G6CoTDLe/iJ7G82RfpfviV
	 NSAZiPSxLZh1Rg9fRn3ZAHDV1xJNzeRP0KQbKinNAlHzYTmVJFKTyzyJwR/5QedA8lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O88E+6Wy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E83606A31A;
	Thu, 29 Oct 2026 12:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O88E+6Wy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BC01F031E4;
	Thu, 29 Oct 2026 12:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275449;
	bh=xlnl9A/D3fizgFoXsRorCiZXKZmn/GF+FXZ2ULqWag8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O88E+6WyIpQz4xx6tnEqL0g+RvaQPnMnKX8KRgBbxiqrIUL1H4Mhf5BEjO0wrHJ5m
	 YMNoAtxNkKsZ1dKWWLLH37HA8DPSedkPzK7SThP4bESzzoK912qsjwOy21KLa1D1xD
	 bTa3sKKN16AqEkSDRMRPg85fMXgimS5bhLBzaX/pKeOBvqfdxsYd+k0yhvim5UBtqU
	 3EJHA8gYwdYPEtSqxFbsj9fE0ZE+m4PzHBw3Fiwq0mnS7Qql4x9UJ2/s6WzdpdE31+
	 JboHEaH+PQ+jKGX6mRyzeLjQldW5fW23Zqr7YVV/wX9gAP1qMXiti9FvHb9jqT37+A
	 L3w5iN72QE8hw==
Date: Thu, 29 Oct 2026 13:04:05 +0100
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Disha Goel <disgoel@linux.ibm.com>
Subject: Re: [PATCH] ovl: fix mount setup failing when override_creds drops
 CAP_SYS_ADMIN
Message-ID: <20261029-laufzeit-ungelegen-gastwirtschaft-4e5eecb7a567@brauner>
References: <20261017165125.2450059-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261017165125.2450059-1-amir73il@gmail.com>

On Sat, Oct 17, 2026 at 06:51:25PM +0200, Amir Goldstein wrote:
> When a process drops CAP_SYS_ADMIN and calls fsconfig(FSCONFIG_SET_FLAG,
> "override_creds"), overlayfs saves those restricted credentials in
> ofs->creator_cred. ovl_fill_super() then wraps the entire mount setup in
> with_ovl_creds(), switching to those restricted credentials for the
> duration.
> 
> Mount setup calls clone_private_mount(), which checks CAP_SYS_ADMIN
> against current credentials. With restricted credentials active, this
> check fails with -EPERM even though the task issuing
> FSCONFIG_CMD_CREATE is fully privileged.
> 
> Use the mounter's real credentials only for cloning the private layer
> mounts. Keep all other backing filesystem operations during mount setup
> under the stashed credentials.
> 
> Reported-by: Disha Goel <disgoel@linux.ibm.com>
> Closes: https://lore.kernel.org/linux-unionfs/20260924112858.51392-1-disgoel@linux.ibm.com
> Fixes: c28f922c9dcee ("clone_private_mnt(): make sure that caller has CAP_SYS_ADMIN in the right userns")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Looks good to me. I like this solution:

Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
