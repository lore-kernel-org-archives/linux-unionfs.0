Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B265427453;
	Fri,  6 Jun 2025 14:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749219831; cv=none; b=CZGkbcSvz8U/dSCkcoewUWsc7xe5P5e5m15XwyWVq3VEpxL1ulXMgNdXvRoOB26IW4I34KWPvei7kMd+7TQQ8zeGa8hIqAaKMEsUk2B2AHzATM3bkTcHa8gAoAnPCnDBJYNRp6h+XMvbHZYmEtSP2gYuZ/1eUhencQ+7gT3bYIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749219831; c=relaxed/simple;
	bh=cF7MTiQ4aehhMsgODbAvbZ1VCffCLfihjULKezSBkCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VyxIR6wkR5R+a2ZeD3ZDkwft3c1LTpIFujcMQBvG4hxooeQQ9Z/dZACXBxHc7JSe4otMamIzH074U8Y/vWT7Vv/aOC4mjAMCldDsy/0hOOWboNiG4xBwvd8SRNFwCCNMHkTZh7nQenXu7i/kK4Gt+0uJmTUA6CD8FeJ1QuIoA8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=YaABVyEC; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="YaABVyEC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=KeWwapmjE7fLRRkxPoHYA74c3LmCIieRbsKEeOk6DdI=; b=YaABVyECg55+kwlAHgOL8yjnQy
	+elaEnYhqfoaOoas2jGEZl84g86hQLhehjI+BXpEinRjJZtjdHVyuayCzFtAblpJnxaMlKLSJ7o8r
	m9BtBpBlSzcUe6zJVC1PZNXsNLnz6ysw+p1OJ+Z7NXiVqoicA0aWGVshN1dc3t704lJqtJTGmoFTd
	mgWnPbPYBi14uWkIyQ4C8Kdy+4EiHVUiSQR2bqgnvXdfRUbA1VefdWK2Zwb6k8i4oHy49XJKZQxIb
	2P80I2XBAgypiFNeR22KCUMXoPc75yAYBAUFTZr7i6nnb26U1dHaA2GB1esd3ZxDFDsBuY5nykgAZ
	J9u9k9hw==;
Received: from 35.red-81-39-190.dynamicip.rima-tde.net ([81.39.190.35] helo=[10.0.21.133])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1uNXyi-000SNs-E1; Fri, 06 Jun 2025 16:23:28 +0200
Message-ID: <bdd067c5-6115-4190-9e64-019607e9cc30@igalia.com>
Date: Fri, 6 Jun 2025 16:23:27 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] overlay: workaround libmount failure to remount,ro
To: Amir Goldstein <amir73il@gmail.com>, Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner
 <brauner@kernel.org>, linux-unionfs@vger.kernel.org,
 fstests@vger.kernel.org, Karel Zak <kzak@redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-2-amir73il@gmail.com>
 <20250605175129.oqqzr5qluxv52m6b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxg2D-ED3vy=jedEKbpEJvWBLD=QYtfp=DCU3pQGGCaGog@mail.gmail.com>
 <20250606011223.gx6xearyoqae5byp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAOQ4uxh9b285dnw+SO2h6HqtNC5Xog0TQSqhFAQaV1brBnVxVQ@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <CAOQ4uxh9b285dnw+SO2h6HqtNC5Xog0TQSqhFAQaV1brBnVxVQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Amir,

On 6/6/25 09:35, Amir Goldstein wrote:
> On Fri, Jun 6, 2025 at 3:12 AM Zorro Lang <zlang@redhat.com> wrote:
>> On Thu, Jun 05, 2025 at 08:30:53PM +0200, Amir Goldstein wrote:
>>> On Thu, Jun 5, 2025 at 7:51 PM Zorro Lang <zlang@redhat.com> wrote:
>>>> On Tue, Jun 03, 2025 at 12:07:40PM +0200, Amir Goldstein wrote:
>>>>> libmount >= v1.39 calls several unneeded fsconfig() calls to reconfigure
>>>>> lowerdir/upperdir when user requests only -o remount,ro.
>>>>>
>>>>> Those calls fail because overlayfs does not allow making any config
>>>>> changes with new mount api, besides MS_RDONLY.
>>>>>
>>>>> We workaround this problem with --options-mode ignore.
>>>>>
>>>>> Reported-by: André Almeida <andrealmeid@igalia.com>
>>>>> Suggested-by: Karel Zak <kzak@redhat.com>
>>>>> Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
>>>>> Link: https://lore.kernel.org/fstests/CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com/
>>>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>>>> ---
>>>>>
>>>>> Changes since v1 [1]:
>>>>> - Change workaround from LIBMOUNT_FORCE_MOUNT2 to --options-mode=ignore
>>>>>
>>>>> [1] https://lore.kernel.org/fstests/20250526143500.1520660-1-amir73il@gmail.com/
>>>> I'm not sure if I understand clearly. Does overlay list are fixing this issue
>>>> on kernel side, then providing a workaround to fstests to avoid the issue be
>>>> triggered too?
>>>>
>>> Noone agreed to fix it on the kernel side.
>>> At least not yet.
>> If so, I have two questions:)
>> 1) Will overlay fix it on kernel or mount util side?
> This is not known at this time.

Do you know how calling fsconfig() in a "redundant" way behaves in other 
filesystems? Do they allow to call fsconfig() calls that doesn't change 
the state, like a noop?

