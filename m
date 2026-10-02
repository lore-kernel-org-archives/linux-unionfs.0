Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB69411A03
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 22:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790980910; cv=none; b=fPjL3mEAmHtgHhTLBr3UrblmBLp3xeZZcVacY2zVfC4oH5JtcCcUm0Vw4GdLMk/moDhGoKyhe8BwvjwH91gioNa+9eOLg5ngjIvd0tQFK/CfZJ8ftlT7os9d/3P+n0A3CbN1p7LDGoCYSGazCULP/WWkreaFOrL8gaROh71283c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790980910; c=relaxed/simple;
	bh=LIjMnQArDasFwAgETuvTs0VfozqwEryyXPgHd0R3c28=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HLe0UatbsAkE8l8nn/lxMUw2NVi7LBXDL4D7dfHTuIS1ElQVPCsIFsc3YFUuNT9MSourTeSomEjuUW+sagVRqNu2C7/6OXGyFmB3rfPr46c1mvv8RYNvHQu2edg2CANt3kFjVKjh3TPqcIy3DEDtO5lw5bBlra8faQh2FNppPJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=CXRRTje/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=AENRBnrF; arc=none smtp.client-ip=202.12.124.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="CXRRTje/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="AENRBnrF"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfout.stl.internal (Postfix) with ESMTP id 5A6A41D00026
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Oct 2026 18:41:48 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Fri, 02 Oct 2026 18:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to; s=fm1; t=1790980908; x=1791067308; bh=dVQET2Hbi6
	rYCysi/1kiAIxyb7/moKG9ZFJ6M+MK9yU=; b=CXRRTje/30Tth0FTMVqS0PGLf/
	ckHqrcSaQZt0j//oYYEuwV8IN7Ff0xf1/UFQRrrUt4yFCbRkueZZld7SZVlNHARj
	KoBL9Zmp+GR8JPwWg7Kv9j8+ZWPPO4EdKnVB5Jzxd6sNczYBBwouhso//YdrxVwc
	sshz03gTthUVdjqpxgoibe492oGkk2/j7W+7YvAGmrlS3asxdYQSkq66bTCjs3KO
	gcABQBJjh/DHKQpMpfG++I6TxZiScwU/BmHdLsE/NhN17/KGM97yrPXQVLmFtjyw
	DhdQGfJ6bESzfJot5fMNLwIAh5SAI3L+pYwK8c7dVTVeT3uzinIE2rHR8ULQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790980908; x=1791067308; bh=dVQET2Hbi6rYCysi/1kiAIxyb7/m
	oKG9ZFJ6M+MK9yU=; b=AENRBnrFa+/hEeAyUnzWskTQuAwm5bWZy+VMGNNmzYju
	yisKwr0ovcf3NXjKy3tOAJZkkAf1DPE6NEGmnoA+Pi0vrvAZdk+mhGh2I3BCBh6S
	xw/537FfvO4aQf5Z+rVfhHLfBSs2kGUhJO3hP4iOMZuksOZ2Zel5/1WcFgUtPAiD
	ZIDrfFmitSsjOBFqHCBkN1yldCqQcnIAt7ltxMVe3K7KSXgA6dLt1zdvo6shqMKj
	ss0Ah0vkfe9LhBP0sJLnOIdZc3wEp0QCfSJdW5/SGyLWR+NXGz5fvytnqvNHSDXi
	qOhH29027pJzdtzGSQIvLIxaICjKn4QbV3EThuEBdw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=sign d=ownmail.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1790980908; d=ownmail.net;
	mf=PG5laWxiQG93bm1haWwubmV0Pg==;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm1:rsa-sha256:W1Kmf0yCrLeuqGuLFi0ZOTf/zN770VBMTSysBTBT8ygpbth
	FcdPFNFbZZ1jzUGetO9zwq47uU4vm9SDlhRaONLejyHhmIah7Y6sGjV0xZBzt3dU
	QhqbaTwt+suRxBbZz2F/wnxpHBr9roe4j3Jplgs0nRSC63+bnyg+01nwqTxi1Etb
	iXQLuvEis0EoIJMJ/B64Fn5ywJKIVre3eJagGm0U5SUUCTU9C9HIkA4bmDlAN6Sg
	kz9vehhDGVkHj4juzC+CC0YH3MnWvKjniuzQ/5F7F+ATfWLy0uRKJmfq7jaIOH6A
	aiHKGXvFN1UAyp8GpE8Jy8lis/+MwujfjmpVzEA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-09-30; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,reply-to,subject,to;
Message-Instance: m=1; h=sha256:E72m+zzisHPU95TshQAMpfOoUGSV3IQQrFwL7mTXt+4=:LIjMnQArDasFwAgETuvTs0VfozqwEryyXPgHd0R3c28=;
X-ME-Sender: <xms:KzPAamjfUuxNzUOybbiwjdUzI5azMKcRryCfwq9hd4w_KUJ2VyXd6A>
    <xme:KzPAalQVWZp3_5nf_5SJM2HoNLUyz2lbGnnBSov04qCTs0bjrp3FtoFzAhP9K8KQk
    R7MUmy7rzCeRUXrw9a84FMwhiw78MEZAmSRCuT_df9Brv19VA>
X-ME-Received: <xmr:KzPAanbQ1TkgcIk9-36as3dlkyK4DvivkcipQUUZlc2K41VqVPU1p-zk6i-lHcjR3EiQaTI8JEIdLkrjReO7Skh_alhkgew>
X-ME-Proxy-Cause: dmFkZTGIHtzcRY7wMs5YzxNCV6Wi7NMBLgeJlrNKJCRpRSucCQqCP6VScWZJVGAvtv0lMQ
    OrK49bdRXqWeJVl37OtZ0+lw4ApIDz371I/ZcXmnsvkk93reSbp3DnzDIzvQn/hr9+FMln
    wRe+qmEyJuEKnHXlc8QOAFkYVsC6VxecGCbGV2o1FHh/pbvjhOMk6Yn+S56MCOQ8wEkArF
    4WBHz2rYYGdrDcjN5ORAX3TUvtof1Cgmd7X9d/0ouQyQxNCjTaiq5tiyacFCt8TGB7UiKB
    sO5FvN2S3FLIKyzRTorQj9vv/tx7fXuwVNmgdu7gM3mb+PHpV+6+FnxBMx4XCf6lj0ATXM
    HbZhX+DcNzhDMzRURJLX7+fz+ZjPNCsNHgbV+k0NKbDLNfU0pWSgoQH5g1LMXU6M/yaft6
    l6ZYcsONHgLVSJR8TcMKo55mErW/yzk7zSBLxxH15CYeNJ5KNtKDBylVEmNuhWpeGLjfH2
    z63Qf8NisI4RTr3tv4T9BawXlvkgK+b9+J/RVBoiuMIEOfwypS3ZotJW55Sr5pBczWIp2d
    FKonprlIqH02luVVZc9R7IQP+k81cycvbZvN2ZCY0QsN6xf4xSOHZmtUQsozSrC9FiK0y4
    4YAnEfrDFjkdIgQZ8xgb/UA8c5litK7iNg8ZkxqwAOQ0udxinFNpHNNWIlew
X-ME-Proxy: <xmx:KzPAaiSZADFYyJXfACVG7naG_F_pPraxPb499IPGnGF-xEeFR1ugpQ>
    <xmx:KzPAam-n0pukDAbXaGrr_9IpcQnaWAwOgoyRLJxGfEEzBVYWT1hLDw>
    <xmx:KzPAaihvpPR4_1Ku0U-9FytxJ1hgSHdf1RRCyuEUq8ebdv7B2639dw>
    <xmx:KzPAanZ9EtcAZqkcIvwXejRXl9JIR3GghaVQOSiZ0tFuugA48VOQyA>
    <xmx:LDPAasVdsiiOJbyf8I3SsHiWe-kK7x1W-6AxTA78d_WskNBoPUnVWi0q>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 2 Oct 2026 18:41:44 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: [PATCH 0/3] Fixes for dentry lockdep tracking on stacking filesystems
Date: Sat,  3 Oct 2026 08:35:41 +1000
Message-ID: <20261002223746.3248726-1-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The recent addition of lockdep tracking for in-lookup dentries didn't
take into account the needs of stacking filesystems.  For this we need
different lock keys for different filesystems in the stack.

Thanks,
NeilBrown


 [PATCH 1/3] VFS: per-fs-type lockdep key for dentry in-lookup locking
 [PATCH 2/3] VFS: rename lookup_map to dep_map
 [PATCH 3/3] ovl: provide private lockdep class for dentry->dep_map
