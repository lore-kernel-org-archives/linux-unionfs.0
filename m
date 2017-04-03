From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] ovl: support freeze/thaw super
Date: Mon, 3 Apr 2017 14:27:26 +0300
Message-ID: <CAOQ4uxjoqSXOKTsp4n+NoRjcAs9qSQYc8dJgsAk3HN0jkhTUZw@mail.gmail.com>
References: <1484828008-27507-1-git-send-email-amir73il@gmail.com>
 <1484828008-27507-2-git-send-email-amir73il@gmail.com> <CAOQ4uxg-i0SMXRTDdPS2GxWKUYDKAu30wT9bjXX1Gd2CzeJ2Yg@mail.gmail.com>
 <588603D7.4060500@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <588603D7.4060500@virtuozzo.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Serge E. Hallyn" <serge@hallyn.com>, Stephane Graber <stgraber@ubuntu.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Pavel Emelyanov <xemul@virtuozzo.com>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jan 23, 2017 at 3:23 PM, Pavel Emelyanov <xemul@virtuozzo.com> wrote:
> On 01/23/2017 11:47 AM, Amir Goldstein wrote:
>> On Thu, Jan 19, 2017 at 2:13 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> freeze/thaw of upper is all that is needed.
>>>
>>
>> Miklos,
>>
>> Looking at it again, I believe that not even that is needed.
>> Having fixed ovl_sync_fs() with patch #2, ovl_freeze()
>> and ovl_unfreeze() need to be NOP. Am I right?
>>
>> In fact, freezing upper fs, when many overlayfs mounts
>> share the same base fs (a-la docker) would be quite lame.
>>
>> WRT other use cases of freezing overlayfs, I am not sure
>> if it is needed for correctness of docker checkpoint/restart?
>>
>> Pavel?
>
> Thanks for the heads-up :)
>
> Good question. Actually we haven't yet experimented with doing _full_
> (with FS) snapshot of containers, but at the first glance I can't
> see the need for OVL freeze :( We stop all the processes in entry.S
> effectively, so no in-flight IO can be happening.
>

Serge, Stephan,

Same question.

Would lxc-snapshot gain anything from the ability to fsfreeze an overlay
mount?

Basically, it should give you the ability to create a consistent snapshot
of overlayfs upper dir from a running container, but maybe you already do
that by freezing the container processes?
I couldn't figure that out from lxc-snapshot documentation.

The context is that I implemented overlayfs fsfreeze for my own needs,
but I need other use cases to justify merging the feature.

Thanks,
Amir.
