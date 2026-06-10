Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D228F30C60C;
	Wed, 10 Jun 2026 07:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781077784; cv=none; b=mE9fN8mM0M0GBkSLWBvrUgAwJRgbyWM03T9T+dMfUT3E6iY/wYx2LuRgzv51ZIzDSFeUuew3Fxi/QGuOvrZb8xFFCuRDmT9gvIzNXO+Fc5wTufQ6ha1npgnsFdBJHko27+6kYKdw+JbY7hWBrZr53N3Q2yeihhHKtPTita6A31E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781077784; c=relaxed/simple;
	bh=F6K+oiah7hXHCubWnvdVmb9nGvSzcHPPTgr5K8R+ytM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r88RxmbCi3NLhxV5cQmQcB5soc8i6yy21woUI4pt5jptK1QQByP2mV1gkOA5hFl/rltHwGV+flMfEv03uADNCq+BnGrof9WOxuOGHG03LQ4gFMTLYwlmDFUMzCiiYRDZgw9tU8j+zabT8ie0dbZteu99G2sbg4WBdUC7zQhb4+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7sc8nY6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7sc8nY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD671F00893;
	Wed, 10 Jun 2026 07:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781077783;
	bh=fNm41Z4DjBBR1sq0J9THwn8rn1scipr+Fg7Qt+cJEdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7sc8nY6fKx6zAP04D84et4zZ4DwJmHdcAt54CeBs9DoOey5ec90f+S28RADGRia9
	 GY97ASJlD2BYVN+IWDWUKwghTQNXEutp9JrL7BtvDvHIhjrbQckh4MfDGViJ3T/iDZ
	 f3vVc5gidcZvFLbZ8G/R7XyxaoUH9HLujF/EqCltRfLYnoPhcgUZv0UEjZL/nk01ZN
	 //hJ7Zcnlbzvm8ttf9cZKUe98oK34o/KYPmHL9eWfMQuUpGz1jsQPoMULfdObKgWVz
	 WwVEf7yiDadWHjph3kJZPGmgCEe3gxKXy+uEop0OsHAz6VZoLw56x+xij8VSAyj7p+
	 T/7LfTLsZn0Ww==
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Li Wang <liwang@kylinos.cn>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] backing-file: fix backing_file_open() kerneldoc parameter
Date: Wed, 10 Jun 2026 09:49:35 +0200
Message-ID: <20260610-rederei-leibhaftig-amten-197492a94472@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260528104208.395757-1-liwang@kylinos.cn>
References: <20260528104208.395757-1-liwang@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1174; i=brauner@kernel.org; h=from:subject:message-id; bh=F6K+oiah7hXHCubWnvdVmb9nGvSzcHPPTgr5K8R+ytM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRpiguKubxakSWVc96uks9SfXGi5hTJH7c0Ftyc5j1nx 9M30aHRHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPhq2H4H7wo80Ax84NHIsc8 5UNnLd7Au6Fa8Ki/YOqGyMZH29N7wxn+cFUvYmpP/acocrdS9u6pjzdd3XfcuNj21L6qU4AtKG8 ODwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Thu, 28 May 2026 18:42:08 +0800, Li Wang wrote:
> The kerneldoc for backing_file_open() documented a @user_path argument,
> but the function takes const struct file *user_file. The user
> path is derived as &user_file->f_path.
> 
> Update the @-tag to @user_file and adjust the description accordingly.
> Also fix the "reuqested" typo to 'requested' in the old comment.
> 
> [...]

Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.2.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.2.misc

[1/1] backing-file: fix backing_file_open() kerneldoc parameter
      https://git.kernel.org/vfs/vfs/c/aa5c4fe3ba0c
