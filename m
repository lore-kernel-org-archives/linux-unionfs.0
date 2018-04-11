Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <AC729CAD-5B27-439D-B899-E592A936DC5C@gmx.com>
References: <1522834036-132136-1-git-send-email-cgxu519@gmx.com>
 <CAOQ4uxgeD6zHm+D1B2H-P4WUpAgK2BgpSw6KXsiyiEaJpSpR9Q@mail.gmail.com> <AC729CAD-5B27-439D-B899-E592A936DC5C@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Apr 2018 10:02:50 +0300
Message-ID: <CAOQ4uxj=_-QJObGu+6BX3JNQCC2Q0KqHS7Z0qWV++5vVa4Cpeg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ovl: add option parsing support for remount
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 11, 2018 at 8:59 AM,  <cgxu519@gmx.com> wrote:
> =E5=9C=A8 2018=E5=B9=B44=E6=9C=884=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=886:4=
4=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Wed, Apr 4, 2018 at 12:27 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
>>> Some overlayfs mount options cannot be changed via remount,
>>> but remount operation does not return proper error even if
>>> we specify different value to unchangeable options.
>>>
>>> This patch add option parsing support for remount so we can
>>> recogonize unchangeable options in remount.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>>> ---
>>>
>>> Changes since v1:
>>> - Add remount option validation to parse_opt()
>>>
>>> fs/overlayfs/super.c | 133 ++++++++++++++++++++++++++++++++++++++++++++=
++++---
>>> 1 file changed, 127 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>> index 7c24619..4112720 100644
>>> --- a/fs/overlayfs/super.c
>>> +++ b/fs/overlayfs/super.c
>>> @@ -425,6 +425,16 @@ static char *ovl_next_opt(char **s)
>>>
>>> static int ovl_parse_redirect_mode(struct ovl_config *config, const cha=
r *mode)
>>> {
>>> +
>>> +       if (!mode) {
>>> +               config->redirect_mode =3D kstrdup(ovl_redirect_mode_def=
(),
>>> +                                                       GFP_KERNEL);
>>> +               if (!config->redirect_mode)
>>> +                       return -ENOMEM;
>>> +
>>> +               mode =3D config->redirect_mode;
>>> +       }
>>
>> This makes @mode argument to function redundant.
>
> Maybe moving default initialization before calling parse_opt() is better,
> what do you think?
>

I think it's ok. Most other options are initialized to default before
parse_opt().

Thanks,
Amir.
