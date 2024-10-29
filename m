Received: from out198-155.us.a.mail.aliyun.com (out198-155.us.a.mail.aliyun.com [47.90.198.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A3D7464
	for <linux-unionfs@vger.kernel.org>; Tue, 29 Oct 2024 11:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730202836; cv=none; b=HQZhCsPfHWBfMG8JZo93axo6R0KxHTPE52GekHZp7C2hH0P5X+jaNKZ7kmD2YOxGscrYcm0O8UKV6KVd/0V5tx2yyhgaGFn2oMKF+XxNk7EP5UBgTX7RB0I0fIzml1TPW6YHW6/0yxioFSQXEqMnki6EEV3VsOfyUDpktHAGelA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730202836; c=relaxed/simple;
	bh=/y1C8Cq9OIGsBI/aWPNQwKy5Q6gp7qM0m+irIHR1o+o=;
	h=Date:From:To:Subject:Message-Id:MIME-Version:Content-Type; b=nZ7BpAT+J8NALtMvffoTHa8ujTT9UFehqX01hEv9maj4uuW8evuc4QrC6pIc7NSTn5lz3yVdomro8qIczB+z6jZeXYpWHCUjTqKUFvD+tKub5H4IuexPr86TCLD0sRyKkpMyWbNDu1pxgzBKEHTVL7jB76dZDS1RMpHtunb0gNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=47.90.198.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.ZvxGw19_1730201885 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 29 Oct 2024 19:38:05 +0800
Date: Tue, 29 Oct 2024 19:38:06 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: linux-unionfs@vger.kernel.org
Subject: Is there other union fs that lowerdir is read-write and upperdir is for metadata cache
Message-Id: <20241029193805.5ABE.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.07 [en]

Hi,

Is there other union fs that
- lowerdir is read-write, not read-only
- upperdir is for metadata cache

so that we can merge multiple small filesystem to one bigger/faster fs?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2024/10/29


