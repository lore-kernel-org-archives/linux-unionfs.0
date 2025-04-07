Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4972153D2
	for <linux-unionfs@vger.kernel.org>; Mon,  7 Apr 2025 21:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744059786; cv=none; b=cq5G/uXoedMn4qpD5rnSS0EHxt0b+1VITGJQrsDWdLT4E64EJfRT72oTGYWh5lOq8NdVdEipcAlmVY3xRhUz//WJN7QX5IDl411xcPp3CQeMA2cC+7kJZB2R/Jf0iTU2p+oP9KdP6BX0owcEWCzGxnLPee7v58T0UcgbnOqJq2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744059786; c=relaxed/simple;
	bh=4ulWWTELilIWBTizVyum5eEbje/DjScnsb3jO0gNZAA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=QUf/3RHhEoLcAm/9/mB6ifZgTk+c49VadWLI+pIyrv6HBiYSZWJq6XSFAl8xuDQqwMHYZlK/sJ4JgRhkIA+93GzlieioOQ4GwfLd/TdyvTNRuzPES98rAazONioWWJE/scmOMgZDIX5F0UFtAgUr5k56jBAIVUDw4AOcU4Alofg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z/Gk/oVu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/Gk/oVu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744059784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4ulWWTELilIWBTizVyum5eEbje/DjScnsb3jO0gNZAA=;
	b=Z/Gk/oVuBfulnTEg12nv77JFJT7qvcEfB6+zmY+5q9CM5YJdT1TOr+YufGDFAvkJ/1k1M4
	XYTYdxIwqzf3e52/2WSwKsYrODTUcMEB4XqyjbqkmqEAxKqwsUSU/I29D966p5fqPXuKhg
	CugCVvBXtRrki29dnCmTgVsAR1VfLpw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-BHyOQiXOPQmKzRiPOJjl9A-1; Mon,
 07 Apr 2025 17:02:25 -0400
X-MC-Unique: BHyOQiXOPQmKzRiPOJjl9A-1
X-Mimecast-MFC-AGG-ID: BHyOQiXOPQmKzRiPOJjl9A_1744059743
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A958D180AF4D;
	Mon,  7 Apr 2025 21:02:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.40])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C6578180B486;
	Mon,  7 Apr 2025 21:02:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <67f3dc05.050a0220.107db6.059d.GAE@google.com>
References: <67f3dc05.050a0220.107db6.059d.GAE@google.com>
To: syzbot <syzbot+4036165fc595a74b09b2@syzkaller.appspotmail.com>
Cc: dhowells@redhat.com, adilger.kernel@dilger.ca, amir73il@gmail.com,
    linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
    linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
    syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [syzbot] [ext4?] [overlayfs?] WARNING in file_seek_cur_needs_f_lock
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1465442.1744059739.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Apr 2025 22:02:19 +0100
Message-ID: <1465443.1744059739@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

syzbot <syzbot+4036165fc595a74b09b2@syzkaller.appspotmail.com> wrote:

> syzbot has tested the proposed patch but the reproducer is still trigger=
ing an issue:
> unregister_netdevice: waiting for DEV to become free
> =

> unregister_netdevice: waiting for batadv0 to become free. Usage count =3D=
 3

I've seen this in a bunch of different syzbot tests also where, as far as =
I
can tell, the patch I've offered fixes the actual bug.

David

