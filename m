From: Mark Salyzyn <salyzyn@android.com>
Subject: Re: [PATCH v6 2/2] overlayfs: override_creds=off option bypass
 creator_cred
Date: Tue, 6 Nov 2018 08:50:16 -0800
Message-ID: <8beaf21a-2242-3c60-4de7-76190b71842b@android.com>
References: <20181105182146.233025-1-salyzyn@android.com>
 <20181105182146.233025-3-salyzyn@android.com>
 <CAOQ4uxjK5UUr7gZ8fOV7A09c+fKG2EnYGhKwty9OXxfjsWSDAA@mail.gmail.com>
 <CAJfpeguesUtcSVsjkG1aT_bW03+HYpLrmP4w4Zo8MYiz1udrcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpeguesUtcSVsjkG1aT_bW03+HYpLrmP4w4Zo8MYiz1udrcQ@mail.gmail.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Vivek Goyal <vgoyal@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Randy Dunlap <rdunlap@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>, overlayfs <linux-unionfs@vger.kernel.org>, linux-doc@vger.kernel.org, kernel-team@android.com
List-Id: linux-unionfs@vger.kernel.org

On 11/06/2018 12:39 AM, Miklos Szeredi wrote:
> On Mon, Nov 5, 2018 at 7:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Mon, Nov 5, 2018 at 8:22 PM Mark Salyzyn <salyzyn@android.com> wrote:
>>> @@ -1549,7 +1569,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>>>                         ovl_dentry_lower(root_dentry), NULL);
>>>
>>>          sb->s_root = root_dentry;
>>> -
>>> +       if (!ofs->config.override_creds)
>>> +               pr_warn("overlayfs: override_creds=off, caller credentials may not be enough to delete file or directories, create nodes, or search directories.\n");
>> The audience is someone that has this feature on by mistake or someone
>> that turn it
>> on without understanding what it does. I am not sure that this is
>> scary enough, but
>> I don't have a better suggestion.
>> Will let others state their opinion.
> I don't think we need any warning message, writing down the rules in
> the documentation should be enough.
I would be pleased to remove them, but maybe more historical background 
is required in the documentation (see below [TL;DR])? I have been told 
to not talk rationalization, history, use cases; but only about side 
effects in the documentation.

Yes, the documentation (in the v7 patch set) cites this problem, so can 
remove this pr_warn in a v8 respin. Does anyone disagree? will respin by 
EOD if nothing said.

[TL;DR]

In 4.4 the default behaviour was effectively !override_creds since the 
mounter or creator MAC and DAC credentials wrapping the existing caller 
credentials had not yet been added until later. Except at that time the 
capabilities were temporarily elevated inside the overlayfs driver 
during the cited operations to (blindly) permit these few.

When the mounter's MAC and DAC credentials were added (later), security 
was greatly improved by not counting on the elevated DAC, but it broke 
the expected 4.4 user space API. So in 4.9 and higher Android will 
require this patch to restore the behaviour that supports 
non-overlapping MAC credentials. But we chose _not_ to re-add the 
(inadvisable) hard coded elevated credentials for these specific 
accesses thus requiring the caller to _have_ the DAC credentials to 
perform them.

- For those using the 4.4 way of doing things, these noted operations work.
- For those using the 4.9 way of doing things, the non-overlapping 
creator and caller MAC credentials broke.
- For latest, this patch brought back the support for non-overlapping 
MAC credentials, without the security issues of the 4.4 implementation, 
but alas breaks the 4.4 way of doing things as noted in this warning 
message.

-- Mark
