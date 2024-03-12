Received: from mail115-24.sinamail.sina.com.cn (mail115-24.sinamail.sina.com.cn [218.30.115.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759AE3AC2B
	for <linux-unionfs@vger.kernel.org>; Tue, 12 Mar 2024 10:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710240915; cv=none; b=Gk9DGH7ad9DiYFR28YhAllJLA7PFWGMu4Er51jd92Akv0YBXrk3GYXopU8bjPtQDE+4uYZA4hAlSM9GWGX1CVvhj1KGhEvhWPgMjILRd3ox6YMx6eBDm0aZUrHudJ9WofU/PZgUb5VyQG5mNiFB0PbwIgQySo0Fa3xKzalCsfRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710240915; c=relaxed/simple;
	bh=j7aDBG8JUvUi8lwL1bWk+WpOhLiCDcBDJp39nC4wfr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZxEe0Pg2eo7O880lBjgTuplbDRtPEcdH/1PRPmx0q2Y7cz2AlaMkuUqyOR9lt9aCm+ERHBZynQZ27oq6KsS8/ZH4RtYK4P1BtMgxxdIvdcPcryh/GJ/QygEM5z2+cbKfhYKHBvQQuMu1pcqadEWWL74st+g8xX9wyy8CpX36O5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; arc=none smtp.client-ip=218.30.115.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([113.88.51.55])
	by sina.com (10.75.12.45) with ESMTP
	id 65F0347F00009958; Tue, 12 Mar 2024 18:54:59 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 8936331457689
X-SMAIL-UIID: D607E81DBBDE4A0C977C9F78490E4453-20240312-185459-1
From: Hillf Danton <hdanton@sina.com>
To: =?UTF-8?q?Wei=C3=9F=2C=20Simone?= <Simone.Weiss@elektrobit.com>
Cc: miklos@szeredi.hu,
	amir73il@gmail.com,
	linux-unionfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: possible deadlock in ovl_llseek 27c1936af506
Date: Tue, 12 Mar 2024 18:54:45 +0800
Message-Id: <20240312105445.2051-1-hdanton@sina.com>
In-Reply-To: <03d7a29c7e1a8c5741680ea9bc83b4fb40358a25.camel@elektrobit.com>
References: 
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 12 Mar 2024 07:10:27 +0000 Weiß, Simone <Simone.Weiss@elektrobit.com>
>
> For some experimentation, I have been running fuzzing campaigns and I
> noticed a possible deadlock in ovl_llseek .

Feel free to take a look at another case of deadlock [1]

[1] https://lore.kernel.org/lkml/ZPOtwcMHN_fpdrpt@boqun-archlinux/
