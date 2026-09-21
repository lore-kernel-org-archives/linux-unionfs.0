Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDA21A683D;
	Mon, 21 Sep 2026 08:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789978972; cv=none; b=l9J2sYS09cmwqLbeJPnhozL6NsBuHbksRVJW9cwY4l4cj9h1ZYdAw20pEa//x22HRLhTIbPlzdlTqCGKB7/wSbLTY0BYFCygCbRsm71q7sWIuQ4P+qv/Lc9kKu4LjoriV+qqp/t1SOGC7CH4z48xPLbAnR5afe+DUOUVQVbOWGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789978972; c=relaxed/simple;
	bh=scuAusXVTkiOicAcLftT6MCD2ahWOssZ2JpvNXJ66Sw=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=JED3JDWxVaBj3vtsv87sNnr+rMY74kkgsd5lBVTQRwrWcTn2kjFgfMjcbavDlhdzDnzV/wQUg9LslDTeHhgT6Tq2mXZVmVDj1i7b9TMwZXjXQ/aGikC/mcwFIPd71iHNhT0/Vnpli82KkQhtIJvwcJSkSh+OATi6QSRl0Vk2aW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=WSCNYOKb; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="WSCNYOKb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=vfOi9CF2LVfWoZ7O5jfd6agl1h9ugqmoM1Bf2hvP0AA=; b=WSCNYOKbouX5
	sYTvpFeYRDFLZeNNwxb2fCVFKLw9vMLRC8RoC65m7tKSBKBsTNZqCSFJtjzcn8Jbx60C9odt6Smbb
	RF1zFoXmlXhU8hrvCPyf5Bru8wfaRQe20k2Y0Qw4KBfzat/VwEY1GTFpiib2aMHEJria2ts/2hN21
	1aSckdSM3IXAvliCLaevIUpaSOdJCXl+uca+yFWzqMdBPDUoBiI508Ys9ceikitrOn+CIVUK8vRXX
	7p0J1RsGMs6Rr1UpP9w+Tt9waDotxly+yzwm0Rc+O3lHdHGLvy/0zaM0RKX80ydLw4K7gvO1izfvF
	e+UtFfxuK5mlB6MNbhVwxw==;
Received: from [::1] (port=49474 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1x8ZIX-00000006wcC-1YgZ;
	Mon, 21 Sep 2026 10:22:48 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 21 Sep 2026 10:22:48 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Amir Goldstein <amir73il@gmail.com>
Cc: brauner@kernel.org, miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] ovl: disable nfs_export for mixed-idmap same-sb
 lower layers
In-Reply-To: <CAOQ4uxjgZ8e=M2yEhqO3mq7WeAUxX3fCNmVwaLStE_Ucqu2EDA@mail.gmail.com>
References: <20260920203239.2876221-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <CAOQ4uxjgZ8e=M2yEhqO3mq7WeAUxX3fCNmVwaLStE_Ucqu2EDA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.6.19
Message-ID: <5ecba8fdffb3ada21ec37fccae0e0675@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-09-21 10:03, Amir Goldstein wrote:
> On Sun, Sep 20, 2026 at 10:33 PM Jérémy Jean
> <Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>> TBH, I don't know whether this layout may actually
>> happen in production, but it looks like a weird feature.
> 
> I do not know either.
> 
> I would like to get feedback from Christian on that, because if this
> setup is not expected I'd rather fail the mount.

Hello Amir,

Thanks for the quick review of this series.
I will wait for Christian to answer before fixing your small remarks
in a v3.

Regards,
Jérémy
