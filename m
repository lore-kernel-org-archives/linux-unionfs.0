Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793373122;
	b=JfNOSawDFEE+m38PWHz2bG0yr1LEXDOk8NUwiIaaKsg6Djjdo9R2RQ0X2zF069FWZwL3
	 sXfJb90IrugOa8I0zZV52v6YpmVvTt5BRVntOYMyaI4i/t7x+3a8JSXwqOnxomdpTLIxQ
	 sgt8ugNLBY8pbfgHGlNbgBou5MdX7maLvLdZkjU2HDW9God0BlL1fGEwoFR8oWqiISwpd
	 wluFpq8y6xu6pX/7qStp+POXPMak4ua6pNnYyctI/944rtEKePT+gm8Cf07yTmI5EAwy5
	 +gWAiLjwXcfwDgARpvV94ehFYPPh7wj/wQI8Q1MXFQvwbeHylTNL/gck8QH+Y/2eKBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793373122;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=Xz4L2PE1s4opxoGiNv7GY/X753OzSirPrx1rscu/iWc=;
	b=3psOJO+BHcBw9nxBjEfYwIgcTywQ//t2U0qypMCR1IIMzfzcI6LAF0ts57rL0bJDsYdN
	 Efe37VdsdYeOBP7uRtL4iFh2S0ia0reLKqvXGcwiW6PIciBX8IBEZQhXpqbgHReMGZ9Tf
	 4ofZtJkzWJi6D6FridbVLXv0Hwflq9CuBCMKOwu+jKH7iOG0n7VSkDNYAgBvn57IBV8CC
	 dUsj/i3qLy5ED310JQw7UF/+Gzv+cECI5+EhuG/9/9nNJMj1vyZ/T/qR2Cb8GZKtCZr1v
	 Va2oNcZF1Ct3xrBn3D1tEVO2/Pt5MzCmRdFjUabDM7my1EpCpU4el8mWfkROEcCBiQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="SON/rSHJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EADF606A31A;
	Fri, 30 Oct 2026 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SON/rSHJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4AB01F000C1;
	Fri, 30 Oct 2026 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793373122;
	bh=Xz4L2PE1s4opxoGiNv7GY/X753OzSirPrx1rscu/iWc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SON/rSHJdyPvjx50TQlnkSPE+R/mz/Um2l9Z7t5LI45fOwa6n7hPNeUZQt9Q9/E0o
	 /YMWIZimi2n/Vuu4DUSFU8Fut3+f3Qlw+T/SpO9Vovb9HQQqCMHiX9sY/6N7xjmpHG
	 3J3cjSh7Vx3bRPB8Ar/oKi3blBA7GcPIofvESURdLqVxsXl/KfH5Yqyr17EWmLZPGM
	 583KcoChvRNHJDOF4llQukVaU5OL06YGHVMLfp6AOraaW1TIPZSVzK5UVWJrUZNA6r
	 lw4AUrI2JQwFEdL1/21UpcbiLWoybA6CVl1C8DxVs1zXQmnczh/WxKoiHMcrk9zO1J
	 MmKQYOJH3ScgQ==
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, Disha Goel <disgoel@linux.ibm.com>
In-Reply-To: <20261017165103.2450042-1-amir73il@gmail.com>
References: <20261017165103.2450042-1-amir73il@gmail.com>
Subject: Re: [PATCH] selftests/ovl: fix detached layer mountinfo
 expectations
Message-Id: <20261030-pluspunkt-kreis-lawinen-274971662578@brauner>
Date: Fri, 30 Oct 2026 16:11:59 +0100
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-ce4c1

On Sat, 17 Oct 2026 18:51:03 +0200, Amir Goldstein wrote:
> set_layers_via_detached_mount_fds was copied from the attached-fd test
> and still looks for /tmp paths. Detached open_tree() layers are recorded
> by d_path() as upperdir=/upper, workdir=/work, and lowerdir+=/ and
> datadir+=/ for each cloned directory. The test has failed since it was
> added.
> 
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] selftests/ovl: fix detached layer mountinfo expectations
      https://git.kernel.org/vfs/vfs/c/8457ca071fab

