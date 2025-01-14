Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCEF15CD41
	for <linux-unionfs@vger.kernel.org>; Tue, 14 Jan 2025 15:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736867725; cv=none; b=bTMrF/exxnXEYFl9Z1Rrz2uUWDxTeCOH25PJrvHpF/vDZIsms0uCryai+bmpRUtZ8qljgFtGU3OO9+sA6LqY7kjGwz2Ifkaryqf5fFH7h6gFVCsqTG2ZR7uGFs7lNJf2klC0XOwEA8VxdNnyDoDCGhcFuwwYKUJXoFYOsFwA4o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736867725; c=relaxed/simple;
	bh=K3tUSupPtYuUw5HqjRbHQLa6qshmLVrEbAQ9VZtLCvQ=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=Cfq+oEa/JiL9q62FxBkdalkwfvFdAvfiro9ci8V9CGvDqfrWrrar6+e8DEKOmJMHYQr45cKggrnsrhRqc0njjY4aC6L7hQ2INMq0HeXioTFnSlSNFojHprP0lWBykIkb+mAyuJHym+uBqiv7WFdPwVRDL60UlCPzO5luI4dF30o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MVK6gesW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MVK6gesW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736867722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cbZzijDFtk90foGzG5nbjJMBB+Z10hsBvZJdQvpjHjM=;
	b=MVK6gesWShZAHuzAAFqP+H7v0TTkXCnGs+cGrvxu80hUtYvWranZSnAMLs7WTLqoHqIkCl
	igho99hJVb/K/RFFmKtuSXsCB14cWOgeuKX5i5OlFJNBk+Q9/wfZqrzdJAJyZlYzNpYL44
	6VE+atkvbggDepgOLZWsNnWutCwbVd8=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-39-Igagn6nkNOehooJA7Cm_Cg-1; Tue,
 14 Jan 2025 10:15:18 -0500
X-MC-Unique: Igagn6nkNOehooJA7Cm_Cg-1
X-Mimecast-MFC-AGG-ID: Igagn6nkNOehooJA7Cm_Cg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BBBA1955D6A;
	Tue, 14 Jan 2025 15:15:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.32])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7B0F83003FD9;
	Tue, 14 Jan 2025 15:15:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: mszeredi@redhat.com
cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: How to support directory opacity in a filesystem for overlayfs to use?
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jan 2025 15:15:14 +0000
Message-ID: <111000.1736867714@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


Hi Mikl=C3=B3s,

What's the best way for a network filesystem to make a native
directory-is-opaque flag available to the system?  Is it best to catch
setxattr/getxattr/removexattr("overlay.opaque") and translate these into the
RPCs to wrangle the flag?

Thanks,
David

