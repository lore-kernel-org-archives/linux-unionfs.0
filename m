Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401273D332B;
	Tue, 30 Jun 2026 03:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782788777; cv=none; b=bZSpkeTrdk1fUv9Mio6Y+L8PtfxCS/6SfAywLwu1HeCx8shXGJimQuh8mtZ8ImHdBwAa5ed8JJDOmr9aTson8oZR/wSZT45ugTekIDGR+FEjAPFSFTGSXA28yOvEGaeu7Y3LnQMgnvmK2jTaWVA/iRxrM3sbxbLLzbyYwMEHXFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782788777; c=relaxed/simple;
	bh=kNjrwoORVthnBf/vBxPfWIiMUiGevlSWW9XXBnF9gCw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=baf3DFJZI49dIR6sLRXFaaXElBDnesfwc8Ch+lOk5m9tjGnRt4dR66FPH1QwbfTPrBoZrUJKCYTCftfE4/z8snqx4haPvEXVqsvW1uRHjnvpWmkcLVuhsZCHK9RcwOLbQDYNvVv8VTLbnY8wtXQnnTjh9PgR8GAd+NblWYORzDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=e0TzzfJq; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="e0TzzfJq"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=42YfSe3DboV3wBjY85azjB4WYifYQz9ou3fKoyJ7f8U=;
	b=e0TzzfJqQZp0DHl/gMR3UsVwky3RfiPDqJyA7juJpiV1Jt0I8ZxFeQbTz7IoSGWghFA7m7/J/
	j9UzKlfapSweOKuqPbI9qNahaYjOSoTXvQbxvSl6kBu6DuricRMXG7HAno3KbY76WHN7pcXYlX4
	gZl8+MUAn4Q6h+pHI5ZSy/k=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gq79B74nnz1T4xK;
	Tue, 30 Jun 2026 10:57:18 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id F34842025F;
	Tue, 30 Jun 2026 11:06:07 +0800 (CST)
Received: from kwepemq200017.china.huawei.com (7.202.195.228) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Jun 2026 11:06:07 +0800
Received: from [10.67.109.91] (10.67.109.91) by kwepemq200017.china.huawei.com
 (7.202.195.228) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 30 Jun
 2026 11:06:06 +0800
Message-ID: <f4c8f5fe-30c3-4e7f-8512-7a2befdd1ed3@huawei.com>
Date: Tue, 30 Jun 2026 11:06:05 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH stable/linux-5.10.y 0/7] Backport Fix incorrect overlayfs
 mmap() and mprotect() LSM access controls
To: Amir Goldstein <amir73il@gmail.com>
CC: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <jack@suse.cz>,
	<miklos@szeredi.hu>, <paul@paul-moore.com>, <jmorris@namei.org>,
	<serge@hallyn.com>, <stephen.smalley.work@gmail.com>, <omosnace@redhat.com>,
	<gregkh@linuxfoundation.org>, <sashal@kernel.org>,
	<bboscaccy@linux.microsoft.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-unionfs@vger.kernel.org>,
	<linux-security-module@vger.kernel.org>, <selinux@vger.kernel.org>,
	<bpf@vger.kernel.org>, <stable@vger.kernel.org>, <lujialin4@huawei.com>
References: <20260629070653.580879-1-caixinchen1@huawei.com>
 <CAOQ4uxjcD0-PHqqmrpEvkLRgtKJGe8-n+6DQyBngjN2TorwU+g@mail.gmail.com>
Content-Language: en-US
From: Cai Xinchen <caixinchen1@huawei.com>
In-Reply-To: <CAOQ4uxjcD0-PHqqmrpEvkLRgtKJGe8-n+6DQyBngjN2TorwU+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200017.china.huawei.com (7.202.195.228)

Thank you for your reply. Regarding the two points of feedback:

First, 6.1 is still in the process of being adapted.

Second, this patch set is primarily intended to fix CVE-2026-46054, but 
it seems that for lower versions to implement SELinux checks for overlay 
mmap/mprotect checks, some dependencies are unavoidable. In such cases, 
should we add more tests to reduce the risk and integrate the changes, 
or should we simply not fix this issue? If more tests are needed, are 
there any recommended test suites?

On 6/30/2026 1:31 AM, Amir Goldstein wrote:
> On Mon, Jun 29, 2026 at 8:38 AM Cai Xinchen <caixinchen1@huawei.com> wrote:
>> ackport the patch series
>> "Fix incorrect overlayfs mmap() and mprotect() LSM access controls" [1]
>> to 5.10 lts
> Chai,
>
> First of all, I don't think that stable maintainers are picking backports
> to 5.10 that were not backported to 6.1 and 5.15.
>
> Second, backporting backing_file as a dependency to LTS kernels is a pretty
> intrusive change, so your description above is very much lacking.
>
> Please do not backport backing_file to any of the LTS kernels without providing
> detailed explanation to try and convince the vfs maintainers that you
> verified this
> bacport is safe for the LTS kernel, because honestly, this looks a bit
> risky for me.
>
> Thanks,
> Amir.
