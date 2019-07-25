From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v10 5/5] overlayfs: override_creds=off option bypass
 creator_cred
Date: Thu, 25 Jul 2019 07:38:54 -0700
Message-ID: <9acceab1-86af-758a-ec00-8f6d33f3da87@android.com>
References: <20190724195719.218307-1-salyzyn@android.com>
 <20190724195719.218307-6-salyzyn@android.com>
 <CAOQ4uxim8zZN5YHZs2OJz5A=3B0U10wyf371yadpe2B7hA8pZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxim8zZN5YHZs2OJz5A=3B0U10wyf371yadpe2B7hA8pZw@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@android.com, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 7/24/19 11:14 PM, Amir Goldstein wrote:
>> +void ovl_revert_creds(const struct cred *old_cred)
>> +{
>> +       if (old_cred)
>> +               revert_creds(old_cred);
>> +}
>> +
> Mark,
>
> Not sure if you have seen my "shutdown" patches:
> https://lore.kernel.org/linux-fsdevel/20190715133839.9878-4-amir73il@gmail.com/

Good to know!

>
> I am fine with this patch, but would like to request that you add @sb arg
> to the ovl_revert_creds() helper, so it is more useful for other things in the
> future that scope the underlying layers access (like shutdown).

Will respin and retest.

-- Mark
