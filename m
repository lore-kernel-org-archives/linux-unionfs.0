Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A74367F39
	for <linux-unionfs@vger.kernel.org>; Fri, 19 Jun 2026 10:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781866265; cv=none; b=Wk4lHGy83oHvALxJMoppWOuHWoU3O0rDgehcpFcx5NX5Q2xb+hVdMluc1RrsQGXmVc87/E3E28D0nZ8+p/zhFvbC8ADVE+JMax9V75jdgUiapM0PIWhpMIORRAosErlYKmFzG6rlt3UQtz8EjJ7Av+RWp2XxtFGn9gnIjtP98ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781866265; c=relaxed/simple;
	bh=vMYClChU/nDPI1mel4GN+SXm9uUJKTLxS7A8nNNkrcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X4PP/NLat+4tkZkg7S6WH/MyhXNu3AOseA6DhKKGRTKxrBADig6bzC7cK85ewyVwYFIcQIjVQsZcxj4Q62GXjNaKyqCYCcY8PfrargT59B9nS/9ahgp4H1J5W/PqxAT5BzbSN1qpJHO5sU+YNv2p/zVtLtIpFOFLXMNOyMqWH/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lW0ZX6y9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lW0ZX6y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29B21F000E9;
	Fri, 19 Jun 2026 10:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781866264;
	bh=MUujH3qFbfe3GmEdxD3XwZQt1WsG4jGSOBkRIiPGK1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lW0ZX6y9WSSAKoid7iGU7Oa6fs5++3fi8wSIxsybcKqKGoTG2X9UaEvdYQb4WkBtN
	 nLmBK1aNqpwYOVO8kNLpu+k6tZ9GG5zu+O4V9rgY0sGsMI1WiKiCDMUtJjp3e+tN2M
	 bODmZSVwV5bkaYLUtsJQO3rqbH0MQAcxi9zUcqySHbt2xvJ/BhlDtF7IRz6QqhHwsw
	 Eu+IsZZor2VZOq88b5yheLrZ2QQ29lr+KjY6oLdUXbzCjmtRrqW2VDVJzbdEuqVLb7
	 uyM4hhUElsys1pvrl+sULVn3+pTDT3T/FraI9XR9wHZ877UmO5F/haAg5Y8tn7KHXh
	 qdqYVv53uXNqQ==
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: fix comment about locking order
Date: Fri, 19 Jun 2026 12:50:59 +0200
Message-ID: <20260619-umkurven-leibhaftig-warnt-781db9f78064@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260609184656.1916631-1-amir73il@gmail.com>
References: <20260609184656.1916631-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=877; i=brauner@kernel.org; h=from:subject:message-id; bh=vMYClChU/nDPI1mel4GN+SXm9uUJKTLxS7A8nNNkrcU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSZygufcVzo4Xp+wr0Dmi4Vky+dK07PuOzLyp934n1s+ apQz37VjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInUXGT4w9/792JPg97f4/8+ 8p4oMlW7Z/bxQalwkczXjD7jC2ceXWX4p8sYeHjN6/9HT+13MJtzJfPuk6Prtp5cO61JV2lyzkP OOUwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 09 Jun 2026 20:46:56 +0200, Amir Goldstein wrote:
> Forgot to update the comment when we changed the locking order.

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

[1/1] ovl: fix comment about locking order
      https://git.kernel.org/vfs/vfs/c/52d2aadd2020
