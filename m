Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A5D1BC07A;
	Mon, 26 May 2025 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748279155; cv=none; b=M6yw4Sa2N8f6DDItbicfflWxg0xWShMkpk1ID21SM2NZqFzmgwdcec6joLtagn8jCM72v6ljeD41Gz3G+HE09SnC5zFUbhkZs+0xiftT8wm35QRAnFKcVhVVODypiqAfBQerx6ephAsLIQzoAR36Sw3+adMeeknQmafu1HFAruo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748279155; c=relaxed/simple;
	bh=xB452GDLlMmqU3tViJ7o8wAa6B7kuI15SmSpGIQoEaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h2tOpkBmCJRgPGiJaOo0fzfSH3N5TmI65KPlGEowu0GanCMgcUixZ5KPa3e0M6O3Xskj3gWWve20e6fa0xSmUED62XNbQ0m7q2tm+H8pKrtI/qc9PQp8eSmQUhscX5Im6qxN0VdY6CRecXx4zbEJ0L8/hjawjPjfu3FQGTwvyKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=UBqg2p0G; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="UBqg2p0G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YjlAIyDdGrC5uGiMRKqCY4uNSnfygHbWDAHZSZbx6BY=; b=UBqg2p0GE09+64E8WGpHtQXTx4
	PKkoBsABlcv7XSchnONXncwA3ds+cyF18tDwj5lEWtfmFVMUags2R+p+C4eVZ35XFbXwaNP17BtAE
	dZADxYgwCz27+ChC5uX1ZozXJ/DRyi/t3RqahMLcAn/pRC3H1ymZkBl/tDEKmjVDVT6hq21l2kXBt
	JfmI5gvxHav2uZhZxUbLyQS/+I5PIv4Fw80N/oSP6P3Gpwd1PWKDXz5S2YOHqDX9ZQ5tjpvIUNyBZ
	7ugnATyh2piebwHgZj0oOwiHTiDljCEhv98qku/GJH2VWxAxgp7j+90KdUNckwaxJA0GzBlk9c2uS
	jhrPLHMA==;
Received: from [191.204.192.64] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1uJbGk-00DOL2-1y; Mon, 26 May 2025 19:05:46 +0200
Message-ID: <0b4a524d-52e3-46e8-b119-255e3e134ef7@igalia.com>
Date: Mon, 26 May 2025 14:05:42 -0300
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] fstests overlay fixes for v2025.05.25
To: Amir Goldstein <amir73il@gmail.com>, Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
 fstests@vger.kernel.org, kernel-dev@igalia.com
References: <20250526143500.1520660-1-amir73il@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <20250526143500.1520660-1-amir73il@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Amir,

Thanks for the fixes!

First of all, you sent two patches for 3/4:
[PATCH 3/4] generic/604: do not run with overlayfs
[PATCH 3/4] generic/604: opt-out with overlayfs

I tested this with Linux 6.15 with the following command:
   $ sudo FSTYPE=ext4 TEST_DIR=/tmp/dir1 TEST_DEV=/dev/vdb 
SCRATCH_DEV=/dev/vdc SCRATCH_MNT=/tmp/dir2 ./check -overlay

These are the results before applying this patchset:

   Failures: generic/294 generic/306 generic/452 generic/599 generic/623 
overlay/019 overlay/035
   Failed 7 of 859 tests

After applying:

   Failures: generic/294 overlay/019
   Failed 2 of 859 tests

So the tests that I reported in my thread are now working.

All patches are:
Tested-by: André Almeida <andrealmeid@igalia.com>

Em 26/05/2025 11:34, Amir Goldstein escreveu:
> Zorro,
> 
> It's been a while since I upgraded my test machine.
> A recent quick run with overlay had some failed tests.
> 
> This fixes some of them and opts-out of some.
> The first patch is a re-post related to upgrade of my distro
> to a newer distro (trixie) using libmount v1.41.
> 
> Thanks,
> Amir.
> 
> Amir Goldstein (4):
>    overlay: workaround libmount failure to remount,ro
>    overlay: fix regression in _repair_overlay_scratch_fs
>    generic/604: do not run with overlayfs
>    generic/623: do not run with overlayfs
> 
>   common/overlay    |  6 +++++-
>   common/rc         |  8 ++++++++
>   tests/generic/330 |  2 +-
>   tests/generic/604 | 11 ++++++-----
>   tests/generic/623 |  1 +
>   tests/overlay/035 |  2 +-
>   6 files changed, 22 insertions(+), 8 deletions(-)
> 

