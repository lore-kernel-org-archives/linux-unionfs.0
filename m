Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D67C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon,  7 Mar 2022 10:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241456AbiCGKyR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 05:54:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241567AbiCGKxq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 Mar 2022 05:53:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38EE1A646C
        for <linux-unionfs@vger.kernel.org>; Mon,  7 Mar 2022 02:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646647968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EAtJPNtZqQT+pzIC8Y0yY8ijMFQMxHJn+7uAlJm9E2A=;
        b=UZ+SDSnDZF+VsXQQefNOfVqNhUYEVXSyB5COW9cgKPDjqCDYYi63cbRm5MbY8glNzzlGYa
        x4DgPQWgUDEb/WE8ygjXLrXp0XGKTG+QHqXsj4YK3Y7s5SIJSsqIRDU2oEoAaqI/kFN7Ow
        YhYnq6VcqsKznBAzdBvLP4T1gcK9vzM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-rJvlNr1nOhq8cCkiOuZR6w-1; Mon, 07 Mar 2022 05:12:47 -0500
X-MC-Unique: rJvlNr1nOhq8cCkiOuZR6w-1
Received: by mail-wr1-f72.google.com with SMTP id k20-20020adfc714000000b001e305cd1597so4364486wrg.19
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Mar 2022 02:12:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=EAtJPNtZqQT+pzIC8Y0yY8ijMFQMxHJn+7uAlJm9E2A=;
        b=d66OV8Ic2Vw/pxnQ8mK0OjkDLi3wAdEtUW3RK/QsKaJfKvar45WD4Cf9cJb4QrBzdl
         WlovYnF4ALo/DOVYIiBo4RsMN3Rmb6BnUtDEQ0G4BfOv/UIFyW+LHITp33zozIWpn9Wq
         uBB3qIU31IE4uNHG6ARPgUpweFFG3Ku2Nduyo47FMwgnEo5eVgC96E4r1j99l4QAE1sb
         Y+XJjuZXJIf6LSOm++Mzjcl6PQB+mZJPZ/dg47XPQdlhv8QzKWKzbUODCAk8Y2aeLGnY
         v7jk5wJiWRL6U8bvym/lSBNbRgyZeG70YhgF5B6fkhfq/fCh/bTNGK1LsbEj87jq5zLc
         ZIJg==
X-Gm-Message-State: AOAM533oIexrHzjFyYOodRcj2ARiJzsoeNNYbGn0oDaU3OncD4NmBgIp
        UtnteoT9ENN3TOXvOVprElayU6rh1bzQ/xKQHolp8bHcLyDmGmgvlKx8A3Qg87zHXMik1atYq1V
        +ddy/Rcif4kPW8QvqyEqlq+Ue7A==
X-Received: by 2002:a5d:6046:0:b0:1f0:4973:142f with SMTP id j6-20020a5d6046000000b001f04973142fmr7674921wrt.538.1646647966518;
        Mon, 07 Mar 2022 02:12:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwEV99RC6J+Vin5f1sKjrk/pcIneCd29UN8hGV1eMibccSf0NvkVF1D5zaL4pxEGhCcclmMGQ==
X-Received: by 2002:a5d:6046:0:b0:1f0:4973:142f with SMTP id j6-20020a5d6046000000b001f04973142fmr7674887wrt.538.1646647966292;
        Mon, 07 Mar 2022 02:12:46 -0800 (PST)
Received: from ?IPV6:2003:cb:c705:1e00:8d67:f75a:a8ae:dc02? (p200300cbc7051e008d67f75aa8aedc02.dip0.t-ipconnect.de. [2003:cb:c705:1e00:8d67:f75a:a8ae:dc02])
        by smtp.gmail.com with ESMTPSA id bg18-20020a05600c3c9200b0037c2ef07493sm14954074wmb.3.2022.03.07.02.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 02:12:45 -0800 (PST)
Message-ID: <d6b09f23-f470-c119-8d3e-7d72a3448b64@redhat.com>
Date:   Mon, 7 Mar 2022 11:12:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RFC 0/3] MAP_POPULATE for device memory
Content-Language: en-US
To:     Jarkko Sakkinen <jarkko@kernel.org>, linux-mm@kvack.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Nathaniel McCallum <nathaniel@profian.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Matthew Auld <matthew.auld@intel.com>,
        =?UTF-8?Q?Thomas_Hellstr=c3=b6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jason Ekstrand <jason@jlekstrand.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        zhangyiru <zhangyiru3@huawei.com>,
        Alexey Gladkov <legion@kernel.org>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        linux-mips@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, codalist@coda.cs.cmu.edu,
        linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20220306053211.135762-1-jarkko@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220306053211.135762-1-jarkko@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On 06.03.22 06:32, Jarkko Sakkinen wrote:
> For device memory (aka VM_IO | VM_PFNMAP) MAP_POPULATE does nothing. Allow
> to use that for initializing the device memory by providing a new callback
> f_ops->populate() for the purpose.
> 
> SGX patches are provided to show the callback in context.
> 
> An obvious alternative is a ioctl but it is less elegant and requires
> two syscalls (mmap + ioctl) per memory range, instead of just one
> (mmap).

What about extending MADV_POPULATE_READ | MADV_POPULATE_WRITE to support
VM_IO | VM_PFNMAP (as well?) ?


-- 
Thanks,

David / dhildenb

