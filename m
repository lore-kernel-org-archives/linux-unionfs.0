Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795184028;
	b=CZu01/Rf89n9DJg3vqfUEy0e6fCQaf0vUkGO3oPYyVlEmMFZWJhN+DnNgvkY9iZp05US
	 g+bwuf0ZCR1kUAJlIhqTdDC3LD9lBkD2JKjS33G3BBnmyaWH1cY/f533tS1L9kqZAqPty
	 i0/AUWJtB/FCevrqoO49U1Jq2PKSgfPd6Je6MkmqlDZMNHvdM5/DP0E785LYEsN0TurOQ
	 A14Xu6l6Mj4QOT9qMndNPQCb8Twmw5Ch2eXAISat1zDeWrKRO2eEnuORIoK6ii+skZjPJ
	 ateOMVexcrgeE63g0fzjWwgxs3LsgtkrF6pUEBrGXrDE7gkZyD83XVAsWf6xni+0zNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795184028;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=p7xxl9ib2LqWIPIDuuTmmVpFcixqIcABe6BvoXtmroY=;
	b=Z4jkni4Gv4YwJtC7Vil+cCoM3t1E2rTwSuPQpkStJlpedkSE1c92KPT+wUQ0Gytnslqq
	 hAbwAAMpz/McscVP5+Yt6JZtJzUDbxI4dAS2SVFuJ3RJ5LDxr+PsoyBqygFWOzZy1coQf
	 fDP5kj3vwmu5PaUbbduzc/0SJTzj3sJf0K0nSQ2aDcSX4cBrHlyfPRaZKIij/F/8qxCSi
	 k1g1/DZ26C0bW+p6iaUiFsX0c4TbjRBZln52EhG0qBSl65JX56ZUUkIYYY5jAZFEs6qrv
	 BKiOTERkAwQjLTmNTCz+4tpEd+jE//deB1Jy07KcjCrMEHgHxp0o5K46s8mEhs+ubsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OcpkTujT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B2E606A325;
	Fri, 20 Nov 2026 14:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OcpkTujT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D0F1F000C6;
	Fri, 20 Nov 2026 14:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795184027;
	bh=p7xxl9ib2LqWIPIDuuTmmVpFcixqIcABe6BvoXtmroY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OcpkTujTra3EqsIxic2PIYwT7E3kKerIKzEEOgEyn7fGTy15YlySl/QtE57TmgqUJ
	 RiWqM0XSpS4wcSKDiOjICof/RZke9GxGuyEMdbIckGW3AtC/lL5y8FRljGu8MpIGxp
	 oetlVXJRiznDvhpKRl4Jy+j46LQNJHqgh/tVCuvrwmR7BZ4a+XLsxlbWQc89Epqfbr
	 UEot67d1cGwfgwEY3TEsrcZachRsEfYiAR62abMn+tIitXpJ8B9AithSGObQ0anX4W
	 XoFOSOhsCu2EJEwdb5bGTqk0H9tRAXFCpT5hUNW4A56SOThRw2eJbVPsdCqlOZLtd0
	 1qDlOGBBvPv5g==
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ding Feng <dingf3ng@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Shuah Khan <shuah@kernel.org>, linux-fsdevel@vger.kernel.org, 
 linux-unionfs@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261119183039.1505892-2-ptikhomirov@virtuozzo.com>
References: <20261119183039.1505892-2-ptikhomirov@virtuozzo.com>
Subject: Re: (subset) [PATCH] selftests/cachestat: add overlayfs test cases
Message-Id: <20261120-zurief-ballon-beinfreiheit-4ff56c59f8fd@brauner>
Date: Fri, 20 Nov 2026 15:13:42 +0100
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
X-Mailer: b4 0.17-dev-04696

On Thu, 19 Nov 2026 19:30:40 +0100, Pavel Tikhomirov wrote:
> Run cachestat() on overlayfs files in four variants. The file is written
> either to the lower dir of an overlayfs or through its mount, so its
> page cache is in the lower or in the upper dir. Then it is opened
> read-only, so it is not copied up, and checked:
> 
> - through the overlayfs mount: the page cache is one stacking level
>   down;
> - through a second overlayfs mount, which has the first one's merged dir
>   as its lower dir: the page cache is two stacking levels down.
> 
> [...]

Applied to the vfs-7.5.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.misc

[1/1] selftests/cachestat: add overlayfs test cases
      https://git.kernel.org/vfs/vfs/c/ab5ec75b9f6d

