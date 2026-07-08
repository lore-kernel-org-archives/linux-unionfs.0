Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD163B5310
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 14:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783521154; cv=none; b=oljGEDT1NvnxSjrf+XZ6zdWwrJiRmE2aPRDd6dmnhU7Kdn/DdmL3b634QQMglrbpmwTbc+ZpRk4GkHSKQ+rURlpYRCeCBd/TflOteDMyCElaHx4bsaxRGZ/6b1naJzTrK6gRYfwFI+Ykc7AXLnwZ+5BsyfmGJJ6/lu9ECmbFr3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783521154; c=relaxed/simple;
	bh=LOeEllHoi+TWL4E3SItVJM1jMccA7PR2St6wIBOhIZ8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RspAsY9eaHPUUTkgL8viiyu9ui5ay0CEXIDaz1wMkfcPpg1G0ls1pM85nTyHNggxObz0FsAO5OfSb+c+0EfM6baA/oRp9BXAiZ5R95i1XVWsJQIAZgEGx1VHqIsr5qVpTRAT2mi+tyy5FdPvWuNBR1mTdkpMhuKrSqT+qkxLduE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IQaCwDvN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IQaCwDvN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783521152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+JLlRmFoV/9EpXUUB3MyVbYbqU3NmpLcJQ510IuP4ZY=;
	b=IQaCwDvN1CWMqS67Se9SKTAhhqCa4NQS4ZuUdWvRpGWzgR4BWH1hEwCY2eZ9bnEprV7db1
	MhcPX2PeQe9XJDYI9NZroYVX56MVkjtIzShtrOtXv6IvU4xJWQLEGINlbdzxAEd1UiqaK8
	A5G74aMEtr1zEluKDuCnJPJvMB9Q6Ag=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-311-EmUh0cirPC-88CyMqHzsXA-1; Wed,
 08 Jul 2026 10:32:28 -0400
X-MC-Unique: EmUh0cirPC-88CyMqHzsXA-1
X-Mimecast-MFC-AGG-ID: EmUh0cirPC-88CyMqHzsXA_1783521147
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7498D18EC1DA;
	Wed,  8 Jul 2026 14:31:57 +0000 (UTC)
Received: from localhost (unknown [10.44.33.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3443E1955D86;
	Wed,  8 Jul 2026 14:31:55 +0000 (UTC)
From: Giuseppe Scrivano <gscrivan@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-api@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: add ioctls to retrieve layer file descriptors
In-Reply-To: <CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
	(Miklos Szeredi's message of "Wed, 8 Jul 2026 16:08:56 +0200")
References: <20260708095831.3381978-1-gscrivan@redhat.com>
	<CAJfpegsJON=1_84PCGMjASYPFL=Wqsz7dnTAbO3Tdz5DfRQU+g@mail.gmail.com>
	<878q7l8y4y.fsf@redhat.com>
	<CAJfpegvQ06=2E0V_ADgxwmo7e5weTfOMozmBB-QVNLLWYAm8WQ@mail.gmail.com>
Date: Wed, 08 Jul 2026 16:31:54 +0200
Message-ID: <87wlv57dt1.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Wed, 8 Jul 2026 at 14:27, Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
>> is there any existing user of such a mechanism?  I don't see any mount
>> specific info under /proc or /sys.
>
> Not yet, but I think it would be good to have one.  It's definitely a
> bigger bite than adding an ioctl(), though.
>
>> >> OVL_IOC_GET_LAYERS_INFO: copy a struct ovl_layers_info to userspace
>> >>                         with numlower, numlowerdata, and has_upper.
>> >
>> > Isn't this info obtainable via statmount(2) already?  If not, it
>> > should be there, instead of a specialized ioctl.
>>
>
>> no that is not exposed by statmount
>
> I mean, you should be able to get that info by counting the lowerdir+,
> datadir+ and upperdir options, no?

Amir suggested to add that functionality when I've asked for some
feedback before sending the patch here.  I am fine to drop it if this is
the consensus although I see its utility from user space.

Regards,
Giuseppe

