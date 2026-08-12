Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED34386576;
	Wed, 12 Aug 2026 07:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786519674; cv=none; b=mvwEdYeSjTtyR2udKJvBAyt2QNzVSfp+a4TuSfglPIQn9K7oiPoQHHwFs/6bXYIDMd9qj0mFck0+cxlz+yXGX9AcwHKcAMun8FXjkXnL945rENPxWTukFchWdI8FMyG1LenyOkonMicNW7emoITbLirPez7Eg7iV41hNTCztEcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786519674; c=relaxed/simple;
	bh=AA40xgGlrspag9jqHVzMXxRdaRl75ymLBMBcmaeUDn4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Z5lZZZpMIRtrPSWhz0OpD1uKWb6UMxyfTDfESJtCxRo06x3EwLb8GyvT8/t9SmCbTJPk1DEnPMU3g+4Wg2Hc66g2R3ryxEY5HqriWzr5TmfNGdEwf9DxZTaBnnStXwS0iDEvAyRNBIijnaw7pK+kR3reDDKfYA0dip2Q18dTZBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFOZ9YQ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFOZ9YQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418541F00ACF;
	Wed, 12 Aug 2026 07:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786519669;
	bh=eWhuCJo4Sc0ofWnzOquBMPtCZHU/TwETIJ0Lz4nmSvs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TFOZ9YQ5etXFlZ5iW6fKnLRkmj7pdcjDNEciAaVDi9vc3i7mYxgpR/wFBEZshOwHE
	 tO8RLycCZJMBiKkA5T4g3aj4ZvInk6InXRp21hpovxhbDg5q2v4EBxfHlO49nBaraV
	 f2rZgelPSuehMa0DiYclFlxu6eWZBiP+YGh8s7TAxFp6hj2ETejbVtg2Uf6NWBpdAM
	 tQNFG4WCYR8pk7H09DlPxB/FMzmoMODicO7qrmETikvI7UQ1SOujR9T8enyUcPBeTN
	 9ZgWL8l+CI9q71MQrb9jH4B4SPJ4kdcKvjvkEQTi25PS/eY5t28AJdefGfM+vauXH1
	 z7nuTrs+V2CsA==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org, Baokun Li <libaokun@linux.alibaba.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, viro@zeniv.linux.org.uk, 
 jack@suse.cz, paul@paul-moore.com, serge@hallyn.com, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20260804034204.3487077-1-libaokun@linux.alibaba.com>
References: <20260804034204.3487077-1-libaokun@linux.alibaba.com>
Subject: Re: [PATCH] fs: fix user path of nested backing files
Message-Id: <20260812-auszog-rehkitz-wonach-182a7eaad0ca@brauner>
Date: Wed, 12 Aug 2026 09:27:43 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=864; i=brauner@kernel.org;
 h=from:subject:message-id; bh=AA40xgGlrspag9jqHVzMXxRdaRl75ymLBMBcmaeUDn4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTVKBTdfMmqKGl4X3jx7MlHdr9ebJz1jJVLU5D/y7RS5
 vLIHXu3dJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkqSUjw/TQIqWlqeL53t0u
 Be+bDDvnbDeXPP7pz+QHLycX/09t+sbwT3PhM6vNS7+VbquWOVujU2Ua4fLe5XVMa+X9pT7y849
 O4AAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Tue, 04 Aug 2026 11:42:04 +0800, Baokun Li wrote:
> fs: fix user path of nested backing files

Applied to the vfs-7.3.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.misc

[1/1] fs: fix user path of nested backing files
      https://git.kernel.org/vfs/vfs/c/ffb5dde2f64a

