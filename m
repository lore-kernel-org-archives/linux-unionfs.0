Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793893933;
	b=yyy/zXU8qEn1GnXH3TrV2qSDNjYHjxEqybpoYPp+6ZSUzeHgL7dOA2Yh4JZC4Xza26q2
	 vGDgx7DB2EUpjH8E1HRI4gpSgK7aHr5x1F9Kgte3DO8BVGvSONUxrYKqmaZGrJg2kGLvh
	 0s4JrdYqwmcZovvPx2V8J4d3kHNVX3fSwYCw/0mtr1ZX43DV9sIoxiWZVBzSOLk5UqjBh
	 VTFk1L3sCfv6q7Rsbf+NzBCxz8+yC2pcWtMda2PjSAQIek3xrwAbpE/sXOshpyW0aR3tn
	 FY3nzmch9eGzyhBT7yLVCT5rkm+C8Hn9d9V6G75JI0urcz6kGkBn1X6c6xoc0bB7vEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793893933;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=9LFv/OFFTK3AEfsD2Od8SCPfw+oFgWojWxuAfHczJkA=;
	b=AyNePBvXjC6ruMUT1RaGalec/TwTi+2+xkTUqFqVfITNLBYGYIIxoM4lHqnyPrNlZAlE
	 1zlfgRuddx746O3K2hP3Wnue95YeYH7D30NVaataYzemNZ4ykPP4txzgLOuZC86cgu90C
	 JvNHYklTPnpZA5Nga9j/z9NfAqD8wJg1TC6qVtOHVDp9BtFJ170d94a34jUKcAnYeURKk
	 3uigkUkQ5l4Qd58aI3maM2xW42huj+M3TQr95l+dBSjTOrTnMNr25tOfD8zLxq1mxKw9n
	 hgYcY5JbfdyKFSVv+9C1upKoJKcrph3BU9FJsNGhveYTocsl1RMDEnNXxN8BfJo1buQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ozt6UcUw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2504D606A333;
	Thu,  5 Nov 2026 15:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ozt6UcUw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430D11F00919;
	Thu,  5 Nov 2026 15:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793893932;
	bh=9LFv/OFFTK3AEfsD2Od8SCPfw+oFgWojWxuAfHczJkA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Ozt6UcUw/ITRIVWsW4MxepetR0U8OFsEX117XJB4ae0BGcCn+Qc1kfFEdDPQc2+rw
	 kJrw5sh8ko9l/r/IqZ5nzVgjfOwl2vGf2F64FUNWDyEfZwYAN5iDS4OdQxxzKh2IyP
	 +lcN4T3r2bmyDLD5iN9Sb0mwnO51xpefaF3I/FEe66q2aiSHjSlZ7XhNDbjClHvbFe
	 Rj8FJxDnxeXiUYVj9b7iHOzG0DHvgYLB0ok7VvmP34BEnCntudCJqOhGbP2Oe3284e
	 P4r+XqZKWEA5W+oK6CVvU2Q4PKpLdvVk1tEdq20xZvpBoIHiFQOIZYrEgn/4IpHZti
	 EmZ04hjBb27Fw==
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-unionfs@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
In-Reply-To: <20261101123440.3184069-1-amir73il@gmail.com>
References: <20261101123440.3184069-1-amir73il@gmail.com>
Subject: Re: [PATCH] backing-file: pass RWF_NOAPPEND to synchronous writes
Message-Id: <20261105-clever-vorkam-selten-176682867893@brauner>
Date: Thu, 05 Nov 2026 16:52:09 +0100
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

On Sun, 01 Nov 2026 13:34:40 +0100, Amir Goldstein wrote:
> pwritev2() with RWF_NOAPPEND ignores the offset and appends the data on
> an overlayfs or FUSE passthrough file that was opened with O_APPEND, and
> the call still returns success. The flag must make the write go to the
> given offset even though the file is in append mode. Any user who can
> write to the file is affected, with the default mount options.
> 
> overlayfs and FUSE passthrough forward the reads and writes on their
> files to a backing file on an underlying filesystem, through the helpers
> in fs/backing-file.c.
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

[1/1] backing-file: pass RWF_NOAPPEND to synchronous writes
      https://git.kernel.org/vfs/vfs/c/104d2190e0b4

